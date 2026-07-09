import 'package:flutter/material.dart';
import 'package:formfrontend/theme.dart';

class FormLayer extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController inputController;
  final String transformationRule;
  final bool isCritical;
  final List<Map<String, dynamic>> capturedInputs;
  final ValueChanged<String?> onRuleChanged;
  final ValueChanged<bool?> onCriticalChanged;
  final VoidCallback onSubmit;

  const FormLayer({
    super.key,
    required this.formKey,
    required this.inputController,
    required this.transformationRule,
    required this.isCritical,
    required this.capturedInputs,
    required this.onRuleChanged,
    required this.onCriticalChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildFormCard(context)),
        SizedBox(width: context.space24),
        Expanded(flex: 2, child: _buildFlowCard(context)),
      ],
    );

    if (isMobile) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFormCard(context),
          SizedBox(height: context.space16),
          _buildFlowCard(context),
        ],
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.space32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Form Layer', style: context.sectionHeading),
          SizedBox(height: context.space4),
          Text(
            'Captures structured input, transitioning awareness to data.',
            style: context.bodyLarge,
          ),
          SizedBox(height: context.space32),
          content,
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.space24),
      decoration: AppCardStyles.elevatedDecoration,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Perceive Raw Input', style: context.labelLarge),
            SizedBox(height: context.space16),
            TextFormField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: 'Input Payload',
                hintText: 'Enter observation data or metric log',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Payload cannot be empty';
                }
                return null;
              },
            ),
            SizedBox(height: context.space16),
            DropdownButtonFormField<String>(
              initialValue: transformationRule,
              decoration: const InputDecoration(
                labelText: 'Interpretation Rule',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Pass-through',
                  child: Text('Pass-through'),
                ),
                DropdownMenuItem(value: 'Log', child: Text('Log')),
                DropdownMenuItem(value: 'Aggregate', child: Text('Aggregate')),
                DropdownMenuItem(value: 'Translate', child: Text('Translate')),
              ],
              onChanged: onRuleChanged,
            ),
            SizedBox(height: context.space16),
            Row(
              children: [
                Checkbox(value: isCritical, onChanged: onCriticalChanged),
                SizedBox(width: context.space8),
                Expanded(
                  child: Text(
                    'Flag as Critical State',
                    style: context.bodyMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.space24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: AppButtonStyles.primary,
                child: const Text('Capture and Store'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.space24),
      decoration: AppCardStyles.flatDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Captured Input Flow', style: context.labelLarge),
          SizedBox(height: context.space16),
          if (capturedInputs.isEmpty)
            Text('No inputs perceived yet.', style: context.bodyMedium)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: capturedInputs.length,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = capturedInputs[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.space16,
                    vertical: context.space8,
                  ),
                  title: Text(
                    item['data'] as String,
                    style: context.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Time: ${item['timestamp']} • Rule: ${item['rule']}',
                    style: context.uiMicro,
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.space8,
                      vertical: context.space2,
                    ),
                    decoration: BoxDecoration(
                      color: item['type'] == 'Critical'
                          ? Colors.red[50]
                          : AppColors.surfaceSubtle,
                      borderRadius: context.borderSm,
                    ),
                    child: Text(
                      item['type'] as String,
                      style: context.uiMicro.copyWith(
                        color: item['type'] == 'Critical'
                            ? Colors.red[700]
                            : AppColors.inkBlack,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
