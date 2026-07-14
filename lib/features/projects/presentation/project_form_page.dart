import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';

class ProjectFormPage extends StatefulWidget {
  final String? projectUuid;

  const ProjectFormPage({super.key, this.projectUuid});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  late Future<ApiResult<Map<String, dynamic>>>? _future;
  final _nameController = TextEditingController();
  final _statusController = TextEditingController(text: 'active');
  final _tagsController = TextEditingController();
  final _adminsController = TextEditingController();
  final _membersController = TextEditingController();
  final _viewersController = TextEditingController();
  final _organizationsController = TextEditingController();
  final _formsController = TextEditingController();
  ApiResult<Map<String, dynamic>>? _saveResult;

  @override
  void initState() {
    super.initState();
    if (widget.projectUuid == null || widget.projectUuid!.isEmpty) {
      _future = null;
      return;
    }
    _future = context.read<ProjectsApi>().getProject(widget.projectUuid!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _tagsController.dispose();
    _adminsController.dispose();
    _membersController.dispose();
    _viewersController.dispose();
    _organizationsController.dispose();
    _formsController.dispose();
    super.dispose();
  }

  List<String> _splitCsv(String value) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  void _loadExisting(Map<String, dynamic> data) {
    if (_nameController.text.isEmpty) {
      _nameController.text = data['name']?.toString() ?? '';
    }
    if (_statusController.text.isEmpty) {
      _statusController.text = data['status']?.toString() ?? 'active';
    }
    if (_tagsController.text.isEmpty && data['tags'] is List) {
      _tagsController.text = (data['tags'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_adminsController.text.isEmpty && data['admins'] is List) {
      _adminsController.text = (data['admins'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_membersController.text.isEmpty && data['members'] is List) {
      _membersController.text = (data['members'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_viewersController.text.isEmpty && data['viewers'] is List) {
      _viewersController.text = (data['viewers'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_organizationsController.text.isEmpty &&
        data['organizations'] is List) {
      _organizationsController.text = (data['organizations'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_formsController.text.isEmpty && data['forms'] is List) {
      _formsController.text = (data['forms'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
  }

  Future<void> _save() async {
    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'status': _statusController.text.trim().isEmpty
          ? 'active'
          : _statusController.text.trim(),
      'tags': _splitCsv(_tagsController.text),
      'admins': _splitCsv(_adminsController.text),
      'members': _splitCsv(_membersController.text),
      'viewers': _splitCsv(_viewersController.text),
      'organizations': _splitCsv(_organizationsController.text),
      'forms': _splitCsv(_formsController.text),
      'versions': const <Map<String, dynamic>>[],
    }..removeWhere((key, value) => value is List && value.isEmpty);

    final api = context.read<ProjectsApi>();
    final result = widget.projectUuid == null || widget.projectUuid!.isEmpty
        ? await api.createProject(payload)
        : await api.updateProject(widget.projectUuid!, payload);
    if (!mounted) return;
    setState(() => _saveResult = result);
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing =
        widget.projectUuid != null && widget.projectUuid!.isNotEmpty;
    final future = _future;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Project' : 'Create Project'),
      ),
      body: future == null
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _textField('Name', _nameController),
                const SizedBox(height: 12),
                _textField('Status', _statusController),
                const SizedBox(height: 12),
                _textField('Tags comma separated', _tagsController),
                const SizedBox(height: 12),
                _textField(
                  'Admins uuids comma separated',
                  _adminsController,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                _textField(
                  'Members uuids comma separated',
                  _membersController,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                _textField(
                  'Viewers uuids comma separated',
                  _viewersController,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                _textField(
                  'Organizations uuids comma separated',
                  _organizationsController,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                _textField(
                  'Forms uuids comma separated',
                  _formsController,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _save,
                  child: Text(isEditing ? 'Save Project' : 'Create Project'),
                ),
                if (_saveResult != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _saveResult!.when(
                      success: (data) => jsonEncode(data),
                      failure: (error) => error.message,
                    ),
                  ),
                ],
              ],
            )
          : FutureBuilder<ApiResult<Map<String, dynamic>>>(
              future: future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return snapshot.data!.when(
                  success: (data) {
                    _loadExisting(data);
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text('UUID: ${data['uuid']?.toString() ?? 'Unknown'}'),
                        const SizedBox(height: 12),
                        _textField('Name', _nameController),
                        const SizedBox(height: 12),
                        _textField('Status', _statusController),
                        const SizedBox(height: 12),
                        _textField('Tags comma separated', _tagsController),
                        const SizedBox(height: 12),
                        _textField(
                          'Admins uuids comma separated',
                          _adminsController,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          'Members uuids comma separated',
                          _membersController,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          'Viewers uuids comma separated',
                          _viewersController,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          'Organizations uuids comma separated',
                          _organizationsController,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          'Forms uuids comma separated',
                          _formsController,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _save,
                          child: const Text('Save Project'),
                        ),
                        if (_saveResult != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _saveResult!.when(
                              success: (data) => jsonEncode(data),
                              failure: (error) => error.message,
                            ),
                          ),
                        ],
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
