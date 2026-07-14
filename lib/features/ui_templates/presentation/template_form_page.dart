import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';

class TemplateFormPage extends StatefulWidget {
  final String? templateUuid;
  final bool isThemeTemplate;

  const TemplateFormPage({
    super.key,
    this.templateUuid,
    required this.isThemeTemplate,
  });

  @override
  State<TemplateFormPage> createState() => _TemplateFormPageState();
}

class _TemplateFormPageState extends State<TemplateFormPage> {
  final _uuidController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _iconController = TextEditingController();
  final _scopeTypeController = TextEditingController(text: 'global');
  final _scopeUuidController = TextEditingController();
  final _visibilityController = TextEditingController(text: 'private');
  final _adminsController = TextEditingController();
  final _editorsController = TextEditingController();
  final _viewersController = TextEditingController();
  final _statusController = TextEditingController(text: 'draft');
  final _initialRevisionUuidController = TextEditingController();
  final _initialRevisionConfigController = TextEditingController();
  final _initialRevisionSchemaController = TextEditingController(text: '1');
  final _initialRevisionStatusController = TextEditingController(text: 'draft');

  @override
  void dispose() {
    _uuidController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _iconController.dispose();
    _scopeTypeController.dispose();
    _scopeUuidController.dispose();
    _visibilityController.dispose();
    _adminsController.dispose();
    _editorsController.dispose();
    _viewersController.dispose();
    _statusController.dispose();
    _initialRevisionUuidController.dispose();
    _initialRevisionConfigController.dispose();
    _initialRevisionSchemaController.dispose();
    _initialRevisionStatusController.dispose();
    super.dispose();
  }

  List<String> _splitCsv(String value) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  Future<void> _save() async {
    final payload = <String, dynamic>{
      'uuid': _uuidController.text.trim(),
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'tags': _splitCsv(_tagsController.text),
      'icon': _iconController.text.trim(),
      'scope_type': _scopeTypeController.text.trim().isEmpty
          ? 'global'
          : _scopeTypeController.text.trim(),
      'scope_uuid': _scopeUuidController.text.trim(),
      'visibility': _visibilityController.text.trim().isEmpty
          ? 'private'
          : _visibilityController.text.trim(),
      'admins': _splitCsv(_adminsController.text),
      'editors': _splitCsv(_editorsController.text),
      'viewers': _splitCsv(_viewersController.text),
      'status': _statusController.text.trim().isEmpty
          ? 'draft'
          : _statusController.text.trim(),
    }..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

    final initialRevisionUuid = _initialRevisionUuidController.text.trim();
    final initialRevisionConfig = _initialRevisionConfigController.text.trim();
    if (initialRevisionUuid.isNotEmpty || initialRevisionConfig.isNotEmpty) {
      payload['initial_revision'] = <String, dynamic>{
        if (initialRevisionUuid.isNotEmpty) 'uuid': initialRevisionUuid,
        'schema_version': int.tryParse(_initialRevisionSchemaController.text.trim()) ?? 1,
        'config': initialRevisionConfig.isEmpty
            ? <String, dynamic>{}
            : jsonDecode(initialRevisionConfig),
        'status': _initialRevisionStatusController.text.trim().isEmpty
            ? 'draft'
            : _initialRevisionStatusController.text.trim(),
      };
    }

    final api = context.read<UiTemplatesApi>();
    final result = widget.isThemeTemplate
        ? await api.createThemeTemplate(payload)
        : await api.createLayoutTemplate(payload);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess ? 'Template created' : result.errorOrNull?.message ?? 'Create failed',
        ),
      ),
    );
    if (result.isSuccess) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isThemeTemplate ? 'Create Theme Template' : 'Create Layout Template';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _uuidController,
            decoration: const InputDecoration(labelText: 'UUID'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(labelText: 'Tags'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _iconController,
            decoration: const InputDecoration(labelText: 'Icon'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _scopeTypeController,
            decoration: const InputDecoration(labelText: 'Scope type'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _scopeUuidController,
            decoration: const InputDecoration(labelText: 'Scope UUID'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _visibilityController,
            decoration: const InputDecoration(labelText: 'Visibility'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _adminsController,
            decoration: const InputDecoration(labelText: 'Admin UUIDs'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _editorsController,
            decoration: const InputDecoration(labelText: 'Editor UUIDs'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _viewersController,
            decoration: const InputDecoration(labelText: 'Viewer UUIDs'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _statusController,
            decoration: const InputDecoration(labelText: 'Status'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _initialRevisionUuidController,
            decoration: const InputDecoration(labelText: 'Initial revision UUID'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _initialRevisionSchemaController,
            decoration: const InputDecoration(labelText: 'Initial revision schema version'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _initialRevisionStatusController,
            decoration: const InputDecoration(labelText: 'Initial revision status'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _initialRevisionConfigController,
            decoration: const InputDecoration(labelText: 'Initial revision config JSON'),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Create Template'),
          ),
        ],
      ),
    );
  }
}
