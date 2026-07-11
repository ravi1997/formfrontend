import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/forms/presentation/widgets/effective_ui_form.dart';

class FormEffectiveUiPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;

  const FormEffectiveUiPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
  });

  @override
  State<FormEffectiveUiPage> createState() => _FormEffectiveUiPageState();
}

class _FormEffectiveUiPageState extends State<FormEffectiveUiPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<FormsApi>().getEffectiveUi(widget.projectUuid, widget.formUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Effective UI')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (ui) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                EffectiveUiForm(
                  ui: ui,
                  includePreviewButton: true,
                ),
              ],
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
