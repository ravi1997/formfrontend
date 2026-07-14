import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';

class FormEditPage extends StatefulWidget {
  final String projectUuid;
  final String? formUuid;

  const FormEditPage({
    super.key,
    required this.projectUuid,
    this.formUuid,
  });

  @override
  State<FormEditPage> createState() => _FormEditPageState();
}

class _FormEditPageState extends State<FormEditPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;
  final _uuidController = TextEditingController();
  final _nameController = TextEditingController();
  final _statusController = TextEditingController();
  final _editorsController = TextEditingController();
  final _viewersController = TextEditingController();
  final _reviewersController = TextEditingController();
  final _approversController = TextEditingController();
  final _submittersController = TextEditingController();
  final _childSectionsController = TextEditingController();
  final _validationConditionsController = TextEditingController();
  final _validationMessagesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _iconController = TextEditingController();
  final _themeTemplateController = TextEditingController();
  final _themeRevisionController = TextEditingController();
  final _layoutTemplateController = TextEditingController();
  final _layoutRevisionController = TextEditingController();
  final _uiOverridesController = TextEditingController();
  final _sectionsController = TextEditingController();
  final _minReviewersController = TextEditingController(text: '0');
  final _minApproversController = TextEditingController(text: '0');
  bool _requiresReviewer = false;
  bool _requiresApprover = false;
  bool _isPublic = false;
  ApiResult<Map<String, dynamic>>? _saveResult;
  bool get _isCreateMode => widget.formUuid == null;

  @override
  void initState() {
    super.initState();
    _future = _isCreateMode
        ? Future.value(
            ApiResult.success(<String, dynamic>{
              'uuid': '',
              'name': '',
              'status': 'active',
            }),
          )
        : context.read<FormsApi>().getForm(
            widget.projectUuid,
            widget.formUuid!,
          );
  }

  @override
  void dispose() {
    _uuidController.dispose();
    _nameController.dispose();
    _statusController.dispose();
    _editorsController.dispose();
    _viewersController.dispose();
    _reviewersController.dispose();
    _approversController.dispose();
    _submittersController.dispose();
    _childSectionsController.dispose();
    _validationConditionsController.dispose();
    _validationMessagesController.dispose();
    _tagsController.dispose();
    _iconController.dispose();
    _themeTemplateController.dispose();
    _themeRevisionController.dispose();
    _layoutTemplateController.dispose();
    _layoutRevisionController.dispose();
    _uiOverridesController.dispose();
    _sectionsController.dispose();
    _minReviewersController.dispose();
    _minApproversController.dispose();
    super.dispose();
  }

  List<String> _splitCsv(String value) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();

  void _loadExisting(Map<String, dynamic> data) {
    if (_uuidController.text.isEmpty) {
      _uuidController.text = data['uuid']?.toString() ?? '';
    }
    if (_nameController.text.isEmpty) {
      _nameController.text = data['name']?.toString() ?? '';
    }
    if (_statusController.text.isEmpty) {
      _statusController.text = data['status']?.toString() ?? 'active';
    }
    if (_editorsController.text.isEmpty && data['editors'] is List) {
      _editorsController.text = (data['editors'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_viewersController.text.isEmpty && data['viewers'] is List) {
      _viewersController.text = (data['viewers'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_reviewersController.text.isEmpty && data['reviewers'] is List) {
      _reviewersController.text = (data['reviewers'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_approversController.text.isEmpty && data['approvers'] is List) {
      _approversController.text = (data['approvers'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_submittersController.text.isEmpty && data['submitters'] is List) {
      _submittersController.text = (data['submitters'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_childSectionsController.text.isEmpty &&
        data['child_sections'] is List) {
      _childSectionsController.text = (data['child_sections'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_validationConditionsController.text.isEmpty &&
        data['validation_conditions'] is List) {
      _validationConditionsController.text =
          (data['validation_conditions'] as List)
              .map((item) => item.toString())
              .join(', ');
    }
    if (_validationMessagesController.text.isEmpty &&
        data['validation_condition_messages'] is Map) {
      _validationMessagesController.text = jsonEncode(
        data['validation_condition_messages'],
      );
    }
    if (_tagsController.text.isEmpty && data['tags'] is List) {
      _tagsController.text = (data['tags'] as List)
          .map((item) => item.toString())
          .join(', ');
    }
    if (_iconController.text.isEmpty) {
      _iconController.text = data['icon']?.toString() ?? '';
    }
    if (_themeTemplateController.text.isEmpty) {
      _themeTemplateController.text =
          data['theme_template_uuid']?.toString() ?? '';
    }
    if (_themeRevisionController.text.isEmpty) {
      _themeRevisionController.text =
          data['theme_revision_uuid']?.toString() ?? '';
    }
    if (_layoutTemplateController.text.isEmpty) {
      _layoutTemplateController.text =
          data['layout_template_uuid']?.toString() ?? '';
    }
    if (_layoutRevisionController.text.isEmpty) {
      _layoutRevisionController.text =
          data['layout_revision_uuid']?.toString() ?? '';
    }
    if (_uiOverridesController.text.isEmpty && data['ui_overrides'] is Map) {
      _uiOverridesController.text = jsonEncode(data['ui_overrides']);
    }
    if (_sectionsController.text.isEmpty && data['sections'] is Map) {
      _sectionsController.text = jsonEncode(data['sections']);
    }
    if (_minReviewersController.text == '0' &&
        data['min_reviewers_required'] != null) {
      _minReviewersController.text = data['min_reviewers_required'].toString();
    }
    if (_minApproversController.text == '0' &&
        data['min_approvers_required'] != null) {
      _minApproversController.text = data['min_approvers_required'].toString();
    }
    _requiresReviewer = data['requires_reviewer'] == true || _requiresReviewer;
    _requiresApprover = data['requires_approver'] == true || _requiresApprover;
    _isPublic = data['is_public'] == true || _isPublic;
  }

  Map<String, String> _parseValidationMessages(String value) {
    if (value.trim().isEmpty) {
      return <String, String>{};
    }
    final decoded = jsonDecode(value);
    if (decoded is! Map) {
      return <String, String>{};
    }
    return decoded.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }

  Future<void> _save() async {
    final payload =
        <String, dynamic>{
          if (_isCreateMode)
            'uuid': _uuidController.text.trim(),
          'name': _nameController.text.trim(),
          'status': _statusController.text.trim().isEmpty
              ? 'active'
              : _statusController.text.trim(),
          'editors': _splitCsv(_editorsController.text),
          'viewers': _splitCsv(_viewersController.text),
          'reviewers': _splitCsv(_reviewersController.text),
          'approvers': _splitCsv(_approversController.text),
          'submitters': _splitCsv(_submittersController.text),
          'requires_reviewer': _requiresReviewer,
          'requires_approver': _requiresApprover,
          'min_reviewers_required':
              int.tryParse(_minReviewersController.text.trim()) ?? 0,
          'min_approvers_required':
              int.tryParse(_minApproversController.text.trim()) ?? 0,
          'validation_conditions': _splitCsv(
            _validationConditionsController.text,
          ),
          'validation_condition_messages': _parseValidationMessages(
            _validationMessagesController.text,
          ),
          'child_sections': _splitCsv(_childSectionsController.text),
          'tags': _splitCsv(_tagsController.text),
          'icon': _iconController.text.trim().isEmpty
              ? null
              : _iconController.text.trim(),
          'theme_template_uuid': _themeTemplateController.text.trim().isEmpty
              ? null
              : _themeTemplateController.text.trim(),
          'theme_revision_uuid': _themeRevisionController.text.trim().isEmpty
              ? null
              : _themeRevisionController.text.trim(),
          'layout_template_uuid': _layoutTemplateController.text.trim().isEmpty
              ? null
              : _layoutTemplateController.text.trim(),
          'layout_revision_uuid': _layoutRevisionController.text.trim().isEmpty
              ? null
              : _layoutRevisionController.text.trim(),
          'ui_overrides': _uiOverridesController.text.trim().isEmpty
              ? <String, dynamic>{}
              : jsonDecode(_uiOverridesController.text),
          'is_public': _isPublic,
          'sections': _sectionsController.text.trim().isEmpty
              ? <String, dynamic>{}
              : jsonDecode(_sectionsController.text),
        }..removeWhere(
          (key, value) =>
              value == null ||
              (value is List && value.isEmpty) ||
              (value is Map && value.isEmpty) ||
              (value is String && value.isEmpty),
        );

    final formsApi = context.read<FormsApi>();
    final result = _isCreateMode
        ? await formsApi.createForm(widget.projectUuid, payload)
        : await formsApi.updateForm(
            widget.projectUuid,
            widget.formUuid!,
            payload,
          );
    if (!mounted) return;
    setState(() => _saveResult = result);
  }

  Widget _field(
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
              _loadExisting(data);
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('UUID: ${data['uuid']?.toString() ?? 'Unknown'}'),
                  if (_isCreateMode) ...[
                    const SizedBox(height: 12),
                    _field('UUID', _uuidController),
                  ],
                  const SizedBox(height: 12),
                  _field('Name', _nameController),
                  const SizedBox(height: 12),
                  _field('Status', _statusController),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _requiresReviewer,
                    onChanged: (value) =>
                        setState(() => _requiresReviewer = value),
                    title: const Text('Requires reviewer'),
                  ),
                  SwitchListTile(
                    value: _requiresApprover,
                    onChanged: (value) =>
                        setState(() => _requiresApprover = value),
                    title: const Text('Requires approver'),
                  ),
                  SwitchListTile(
                    value: _isPublic,
                    onChanged: (value) => setState(() => _isPublic = value),
                    title: const Text('Public form'),
                  ),
                  const SizedBox(height: 12),
                  _field('Min reviewers required', _minReviewersController),
                  const SizedBox(height: 12),
                  _field('Min approvers required', _minApproversController),
                  const SizedBox(height: 12),
                  _field(
                    'Editors uuids comma separated',
                    _editorsController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Viewers uuids comma separated',
                    _viewersController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Reviewers uuids comma separated',
                    _reviewersController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Approvers uuids comma separated',
                    _approversController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Submitters uuids comma separated',
                    _submittersController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Child sections uuids comma separated',
                    _childSectionsController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Validation conditions uuids comma separated',
                    _validationConditionsController,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Validation condition messages JSON',
                    _validationMessagesController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  _field('Tags comma separated', _tagsController, maxLines: 2),
                  const SizedBox(height: 12),
                  _field('Icon', _iconController),
                  const SizedBox(height: 12),
                  _field('Theme template uuid', _themeTemplateController),
                  const SizedBox(height: 12),
                  _field('Theme revision uuid', _themeRevisionController),
                  const SizedBox(height: 12),
                  _field('Layout template uuid', _layoutTemplateController),
                  const SizedBox(height: 12),
                  _field('Layout revision uuid', _layoutRevisionController),
                  const SizedBox(height: 12),
                  _field(
                    'UI overrides JSON',
                    _uiOverridesController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  _field('Sections JSON map', _sectionsController, maxLines: 6),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Form'),
                  ),
                  if (_saveResult != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _saveResult!.when(
                        success: (saved) => jsonEncode(saved),
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
