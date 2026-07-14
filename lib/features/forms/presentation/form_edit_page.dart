import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';

class FormEditPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;

  const FormEditPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
  });

  @override
  State<FormEditPage> createState() => _FormEditPageState();
}

class _FormEditPageState extends State<FormEditPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  final _descriptionController = TextEditingController();
  ApiResult<Map<String, dynamic>>? _saveResult;
  Map<String, dynamic>? _loadedData;

  @override
  void initState() {
    super.initState();
    _future = context.read<FormsApi>().getForm(widget.projectUuid, widget.formUuid);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'status': _statusController.text.trim(),
      'description': _descriptionController.text.trim(),
    }..removeWhere((key, value) => value == null || value.toString().isEmpty);

    final result = await context.read<FormsApi>().updateForm(
          widget.projectUuid,
          widget.formUuid,
          payload,
        );
    if (!mounted) return;
    setState(() => _saveResult = result);
  }

  Widget _fieldCard({
    required String title,
    required Widget child,
    String? helperText,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (helperText != null) ...[
              const SizedBox(height: 8),
              Text(helperText),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Edit')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (data) {
              _loadedData ??= data;
              _nameController.text = _nameController.text.isEmpty ? (data['name']?.toString() ?? '') : _nameController.text;
              _statusController.text = _statusController.text.isEmpty ? (data['status']?.toString() ?? '') : _statusController.text;
              _descriptionController.text = _descriptionController.text.isEmpty ? (data['description']?.toString() ?? '') : _descriptionController.text;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _fieldCard(
                    title: 'Form summary',
                    helperText: 'Edit the backend fields that this form accepts.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UUID: ${data['uuid']?.toString() ?? 'Unknown'}'),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _statusController,
                          decoration: const InputDecoration(labelText: 'Status'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _fieldCard(
                    title: 'Loaded payload',
                    child: SelectableText(data.toString()),
                  ),
                  const SizedBox(height: 16),
                  _fieldCard(
                    title: 'Save result',
                    child: _saveResult == null
                        ? const Text('No changes saved yet.')
                        : _saveResult!.when(
                            success: (saved) => SelectableText(saved.toString()),
                            failure: (error) => Text(error.message),
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Form'),
                  ),
                ],
              );
            },
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
