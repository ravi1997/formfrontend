import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';

class SectionEditPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;

  const SectionEditPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
  });

  @override
  State<SectionEditPage> createState() => _SectionEditPageState();
}

class _SectionEditPageState extends State<SectionEditPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _statusController = TextEditingController(text: 'active');
  final _tagsController = TextEditingController();
  ApiResult<Map<String, dynamic>>? _saveResult;

  @override
  void initState() {
    super.initState();
    _future = context.read<SectionsApi>().getSection(
      projectUuid: widget.projectUuid,
      formUuid: widget.formUuid,
      sectionUuid: widget.sectionUuid,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _loadExisting(Map<String, dynamic> data) {
    if (_titleController.text.isEmpty) {
      _titleController.text = data['title']?.toString() ?? '';
    }
    if (_descriptionController.text.isEmpty) {
      _descriptionController.text = data['description']?.toString() ?? '';
    }
    if (_statusController.text.isEmpty) {
      _statusController.text = data['status']?.toString() ?? 'active';
    }
    if (_tagsController.text.isEmpty && data['tags'] is List) {
      _tagsController.text = (data['tags'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
  }

  List<String> _splitCsv(String value) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  Future<void> _save() async {
    final payload = <String, dynamic>{
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'status': _statusController.text.trim().isEmpty
          ? 'active'
          : _statusController.text.trim(),
      'tags': _splitCsv(_tagsController.text),
    }..removeWhere((key, value) => value is List && value.isEmpty);
    final result = await context.read<SectionsApi>().updateSection(
      projectUuid: widget.projectUuid,
      formUuid: widget.formUuid,
      sectionUuid: widget.sectionUuid,
      payload: payload,
    );
    if (!mounted) return;
    setState(() => _saveResult = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Section Edit')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
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
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _statusController,
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags comma separated',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Section'),
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
