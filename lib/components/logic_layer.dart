import 'package:flutter/material.dart';
import 'package:formfrontend/theme.dart';

class LogicLayer extends StatelessWidget {
  const LogicLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.space32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Logic Layer', style: context.sectionHeading),
          SizedBox(height: context.space4),
          Text(
            'Processes transformations through a DAG-based lifecycle system.',
            style: context.bodyLarge,
          ),
          SizedBox(height: context.space32),
          Container(
            padding: EdgeInsets.all(context.space24),
            decoration: AppCardStyles.elevatedDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transformation Workflow DAG', style: context.labelLarge),
                SizedBox(height: context.space24),
                isMobile
                    ? _buildMobileDagLayout(context)
                    : _buildDagLayout(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDagLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDagNode(context, 'Awareness', 'Input Perception', true),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.borderLight,
            ),
            _buildDagNode(context, 'Data', 'Structured Storage', true),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.borderLight,
            ),
            _buildDagNode(
              context,
              'Interpretation',
              'Rule Transformation',
              false,
            ),
          ],
        ),
        SizedBox(height: context.space24),
        const Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_downward_rounded,
            color: AppColors.borderLight,
          ),
        ),
        SizedBox(height: context.space24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDagNode(context, 'Insight', 'Final Comprehension', false),
            const Icon(Icons.arrow_back_rounded, color: AppColors.borderLight),
            _buildDagNode(context, 'Generation', 'Visual Creation', false),
            const Icon(Icons.arrow_back_rounded, color: AppColors.borderLight),
            _buildDagNode(context, 'Observation', 'Relation Mapping', false),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileDagLayout(BuildContext context) {
    return Column(
      children: [
        _buildDagNode(
          context,
          'Awareness',
          'Input Perception',
          true,
          fullWidth: true,
        ),
        SizedBox(height: context.space8),
        const Icon(Icons.arrow_downward_rounded, color: AppColors.borderLight),
        SizedBox(height: AppSpacing.space8),
        _buildDagNode(
          context,
          'Data',
          'Structured Storage',
          true,
          fullWidth: true,
        ),
        SizedBox(height: context.space8),
        const Icon(Icons.arrow_downward_rounded, color: AppColors.borderLight),
        SizedBox(height: context.space8),
        _buildDagNode(
          context,
          'Interpretation',
          'Rule Transformation',
          false,
          fullWidth: true,
        ),
        SizedBox(height: context.space8),
        const Icon(Icons.arrow_downward_rounded, color: AppColors.borderLight),
        SizedBox(height: context.space8),
        _buildDagNode(
          context,
          'Observation',
          'Relation Mapping',
          false,
          fullWidth: true,
        ),
        SizedBox(height: context.space8),
        const Icon(Icons.arrow_downward_rounded, color: AppColors.borderLight),
        SizedBox(height: context.space8),
        _buildDagNode(
          context,
          'Generation',
          'Visual Creation',
          false,
          fullWidth: true,
        ),
        SizedBox(height: context.space8),
        const Icon(Icons.arrow_downward_rounded, color: AppColors.borderLight),
        SizedBox(height: context.space8),
        _buildDagNode(
          context,
          'Insight',
          'Final Comprehension',
          false,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildDagNode(
    BuildContext context,
    String title,
    String subtitle,
    bool isCompleted, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : 160,
      padding: EdgeInsets.all(context.space16),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.inkBlack : AppColors.pureWhite,
        borderRadius: context.borderLg,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppShadows.cardFlat,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.labelMedium.copyWith(
              color: isCompleted ? AppColors.pureWhite : AppColors.inkBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.space4),
          Text(
            subtitle,
            style: context.uiMicro.copyWith(
              color: isCompleted ? AppColors.greyMuted : AppColors.greyBody,
            ),
          ),
        ],
      ),
    );
  }
}
