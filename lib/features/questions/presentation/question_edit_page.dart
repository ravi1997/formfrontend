import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';

class QuestionEditPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;
  final String questionUuid;

  const QuestionEditPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
    required this.questionUuid,
  });

  @override
  State<QuestionEditPage> createState() => _QuestionEditPageState();
}

class _QuestionEditPageState extends State<QuestionEditPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;
  final _labelController = TextEditingController();
  final _typeController = TextEditingController();
  final _placeholderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _helpTextController = TextEditingController();
  final _tooltipController = TextEditingController();
  final _defaultValueController = TextEditingController();
  final _statusController = TextEditingController(text: 'active');
  final _validationConditionsController = TextEditingController();
  final _validationMessagesController = TextEditingController();
  final _visibilityConditionsController = TextEditingController();
  final _repeatableConditionController = TextEditingController();
  final _checkRepeatOnController = TextEditingController();
  final _minRepeatableCountController = TextEditingController();
  final _maxRepeatableCountController = TextEditingController();
  final _actionButtonTypeController = TextEditingController();
  final _actionTypeController = TextEditingController();
  final _actionLabelController = TextEditingController();
  final _actionsController = TextEditingController();
  final _tagsController = TextEditingController();
  final _choicesController = TextEditingController();
  final _actionIconController = TextEditingController();
  bool _addButton = false;
  bool _isRepeatable = false;
  bool _isAction = false;
  bool _hideButton = false;
  ApiResult<Map<String, dynamic>>? _saveResult;

  @override
  void initState() {
    super.initState();
    _future = context.read<QuestionsApi>().getQuestion(
      projectUuid: widget.projectUuid,
      formUuid: widget.formUuid,
      sectionUuid: widget.sectionUuid,
      questionUuid: widget.questionUuid,
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _typeController.dispose();
    _placeholderController.dispose();
    _descriptionController.dispose();
    _helpTextController.dispose();
    _tooltipController.dispose();
    _defaultValueController.dispose();
    _statusController.dispose();
    _validationConditionsController.dispose();
    _validationMessagesController.dispose();
    _visibilityConditionsController.dispose();
    _repeatableConditionController.dispose();
    _checkRepeatOnController.dispose();
    _minRepeatableCountController.dispose();
    _maxRepeatableCountController.dispose();
    _actionButtonTypeController.dispose();
    _actionTypeController.dispose();
    _actionLabelController.dispose();
    _actionsController.dispose();
    _tagsController.dispose();
    _choicesController.dispose();
    _actionIconController.dispose();
    super.dispose();
  }

  void _loadExisting(Map<String, dynamic> data) {
    if (_labelController.text.isEmpty) {
      _labelController.text = data['label']?.toString() ?? '';
    }
    if (_typeController.text.isEmpty) {
      _typeController.text = data['type']?.toString() ?? '';
    }
    if (_placeholderController.text.isEmpty) {
      _placeholderController.text = data['placeholder']?.toString() ?? '';
    }
    if (_descriptionController.text.isEmpty) {
      _descriptionController.text = data['description']?.toString() ?? '';
    }
    if (_helpTextController.text.isEmpty) {
      _helpTextController.text = data['help_text']?.toString() ?? '';
    }
    if (_tooltipController.text.isEmpty) {
      _tooltipController.text = data['tooltip']?.toString() ?? '';
    }
    if (_defaultValueController.text.isEmpty &&
        data.containsKey('default_value')) {
      _defaultValueController.text = jsonEncode(data['default_value']);
    }
    if (_statusController.text.isEmpty) {
      _statusController.text = data['status']?.toString() ?? 'active';
    }
    if (_choicesController.text.isEmpty && data['choices'] is List) {
      _choicesController.text = jsonEncode(data['choices']);
    }
    if (_validationConditionsController.text.isEmpty &&
        data['validation_conditions'] is List) {
      _validationConditionsController.text =
          (data['validation_conditions'] as List).map((e) => e.toString()).join(', ');
    }
    if (_validationMessagesController.text.isEmpty &&
        data['validation_condition_messages'] is Map) {
      _validationMessagesController.text = jsonEncode(data['validation_condition_messages']);
    }
    if (_visibilityConditionsController.text.isEmpty &&
        data['visibility_conditions'] is List) {
      _visibilityConditionsController.text =
          (data['visibility_conditions'] as List).map((e) => e.toString()).join(', ');
    }
    if (_repeatableConditionController.text.isEmpty) {
      _repeatableConditionController.text = data['repeatable_condition']?.toString() ?? '';
    }
    if (_checkRepeatOnController.text.isEmpty) {
      _checkRepeatOnController.text = data['check_repeat_on']?.toString() ?? '';
    }
    if (_minRepeatableCountController.text.isEmpty && data['min_repeatable_count'] != null) {
      _minRepeatableCountController.text = data['min_repeatable_count'].toString();
    }
    if (_maxRepeatableCountController.text.isEmpty && data['max_repeatable_count'] != null) {
      _maxRepeatableCountController.text = data['max_repeatable_count'].toString();
    }
    if (_actionButtonTypeController.text.isEmpty) {
      _actionButtonTypeController.text = data['actionButtonType']?.toString() ?? '';
    }
    if (_actionTypeController.text.isEmpty) {
      _actionTypeController.text = data['actionType']?.toString() ?? '';
    }
    if (_actionLabelController.text.isEmpty) {
      _actionLabelController.text = data['actionLabel']?.toString() ?? '';
    }
    if (_actionsController.text.isEmpty && data['actions'] is List) {
      _actionsController.text = jsonEncode(data['actions']);
    }
    if (_tagsController.text.isEmpty && data['tags'] is List) {
      _tagsController.text = (data['tags'] as List).map((e) => e.toString()).join(', ');
    }
    if (_actionIconController.text.isEmpty) {
      _actionIconController.text = data['actionIcon']?.toString() ?? '';
    }
    _addButton = data['add_button'] == true || _addButton;
    _isRepeatable = data['is_repeatable'] == true || _isRepeatable;
    _isAction = data['isAction'] == true || _isAction;
    _hideButton = data['hideButton'] == true || _hideButton;
  }

  List<Map<String, dynamic>> _parseChoices(String value) {
    final decoded = jsonDecode(value.isEmpty ? '[]' : value);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<String> _splitCsv(String value) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  Future<void> _save() async {
    final payload =
        <String, dynamic>{
          'label': _labelController.text.trim(),
          'type': _typeController.text.trim(),
          'placeholder': _placeholderController.text.trim(),
          'description': _descriptionController.text.trim(),
          'help_text': _helpTextController.text.trim(),
          'tooltip': _tooltipController.text.trim(),
          'default_value': _defaultValueController.text.trim().isEmpty
              ? null
              : jsonDecode(_defaultValueController.text),
          'status': _statusController.text.trim().isEmpty
              ? 'active'
              : _statusController.text.trim(),
          'validation_conditions': _splitCsv(_validationConditionsController.text),
          'validation_condition_messages': _validationMessagesController.text.trim().isEmpty
              ? <String, dynamic>{}
              : jsonDecode(_validationMessagesController.text),
          'visibility_conditions': _splitCsv(_visibilityConditionsController.text),
          'add_button': _addButton,
          'is_repeatable': _isRepeatable,
          'repeatable_condition': _repeatableConditionController.text.trim(),
          'check_repeat_on': _checkRepeatOnController.text.trim(),
          'min_repeatable_count': int.tryParse(_minRepeatableCountController.text.trim()),
          'max_repeatable_count': int.tryParse(_maxRepeatableCountController.text.trim()),
          'isAction': _isAction,
          'actionButtonType': _actionButtonTypeController.text.trim(),
          'actionType': _actionTypeController.text.trim(),
          'actionLabel': _actionLabelController.text.trim(),
          'actions': _actionsController.text.trim().isEmpty
              ? const []
              : jsonDecode(_actionsController.text),
          'tags': _splitCsv(_tagsController.text),
          'choices': _choicesController.text.trim().isEmpty
              ? const []
              : _parseChoices(_choicesController.text),
          'hideButton': _hideButton,
          'actionIcon': _actionIconController.text.trim(),
        }..removeWhere(
          (key, value) =>
              value == null ||
              (value is List && value.isEmpty) ||
              (value is String && value.isEmpty),
        );

    final result = await context.read<QuestionsApi>().updateQuestion(
      projectUuid: widget.projectUuid,
      formUuid: widget.formUuid,
      sectionUuid: widget.sectionUuid,
      questionUuid: widget.questionUuid,
      payload: payload,
    );
    if (!mounted) return;
    setState(() => _saveResult = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Edit')),
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
                    controller: _labelController,
                    decoration: const InputDecoration(labelText: 'Label'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _typeController,
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _placeholderController,
                    decoration: const InputDecoration(labelText: 'Placeholder'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _helpTextController,
                    decoration: const InputDecoration(labelText: 'Help text'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tooltipController,
                    decoration: const InputDecoration(labelText: 'Tooltip'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _defaultValueController,
                    decoration: const InputDecoration(
                      labelText: 'Default value JSON',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _addButton,
                    onChanged: (value) => setState(() => _addButton = value),
                    title: const Text('Add button'),
                  ),
                  SwitchListTile(
                    value: _isRepeatable,
                    onChanged: (value) => setState(() => _isRepeatable = value),
                    title: const Text('Repeatable'),
                  ),
                  SwitchListTile(
                    value: _isAction,
                    onChanged: (value) => setState(() => _isAction = value),
                    title: const Text('Action question'),
                  ),
                  SwitchListTile(
                    value: _hideButton,
                    onChanged: (value) => setState(() => _hideButton = value),
                    title: const Text('Hide button'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _validationConditionsController,
                    decoration: const InputDecoration(labelText: 'Validation conditions'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _validationMessagesController,
                    decoration: const InputDecoration(labelText: 'Validation condition messages JSON'),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _visibilityConditionsController,
                    decoration: const InputDecoration(labelText: 'Visibility conditions'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _repeatableConditionController,
                    decoration: const InputDecoration(labelText: 'Repeatable condition'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _checkRepeatOnController,
                    decoration: const InputDecoration(labelText: 'Check repeat on'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _minRepeatableCountController,
                    decoration: const InputDecoration(labelText: 'Min repeatable count'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _maxRepeatableCountController,
                    decoration: const InputDecoration(labelText: 'Max repeatable count'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _actionButtonTypeController,
                    decoration: const InputDecoration(labelText: 'Action button type'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _actionTypeController,
                    decoration: const InputDecoration(labelText: 'Action type'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _actionLabelController,
                    decoration: const InputDecoration(labelText: 'Action label'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _actionsController,
                    decoration: const InputDecoration(labelText: 'Actions JSON array'),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tagsController,
                    decoration: const InputDecoration(labelText: 'Tags'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _statusController,
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _choicesController,
                    decoration: const InputDecoration(
                      labelText: 'Choices JSON array',
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _actionIconController,
                    decoration: const InputDecoration(labelText: 'Action icon'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Question'),
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
