import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';

class ChoiceEditPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;
  final String questionUuid;
  final String? choiceUuid;

  const ChoiceEditPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
    required this.questionUuid,
    this.choiceUuid,
  });

  @override
  State<ChoiceEditPage> createState() => _ChoiceEditPageState();
}

class _ChoiceEditPageState extends State<ChoiceEditPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;
  final _labelController = TextEditingController();
  final _valueController = TextEditingController();
  final _visibilityConditionController = TextEditingController();
  ApiResult<Map<String, dynamic>>? _saveResult;

  @override
  void initState() {
    super.initState();
    if (widget.choiceUuid == null) {
      _future = Future.value(ApiResult.success(<String, dynamic>{}));
      return;
    }
    _future = context.read<ChoicesApi>().getChoice(
      projectUuid: widget.projectUuid,
      formUuid: widget.formUuid,
      sectionUuid: widget.sectionUuid,
      questionUuid: widget.questionUuid,
      choiceUuid: widget.choiceUuid!,
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _valueController.dispose();
    _visibilityConditionController.dispose();
    super.dispose();
  }

  void _loadExisting(Map<String, dynamic> data) {
    if (_labelController.text.isEmpty) {
      _labelController.text = data['label']?.toString() ?? '';
    }
    if (_valueController.text.isEmpty) {
      _valueController.text = data['value']?.toString() ?? '';
    }
    if (_visibilityConditionController.text.isEmpty) {
      _visibilityConditionController.text =
          data['visibility_condition']?.toString() ?? '';
    }
  }

  Future<void> _save() async {
    final isCreate = widget.choiceUuid == null;
    final payload = <String, dynamic>{
      'label': _labelController.text.trim(),
      'value': _valueController.text.trim(),
      'visibility_condition': _visibilityConditionController.text.trim().isEmpty
          ? null
          : _visibilityConditionController.text.trim(),
    }..removeWhere((key, value) => value == null || value.toString().isEmpty);

    final choicesApi = context.read<ChoicesApi>();
    final result = isCreate
        ? await choicesApi.createChoice(
            projectUuid: widget.projectUuid,
            formUuid: widget.formUuid,
            sectionUuid: widget.sectionUuid,
            questionUuid: widget.questionUuid,
            payload: payload,
          )
        : await choicesApi.updateChoice(
            projectUuid: widget.projectUuid,
            formUuid: widget.formUuid,
            sectionUuid: widget.sectionUuid,
            questionUuid: widget.questionUuid,
            choiceUuid: widget.choiceUuid!,
            payload: payload,
          );
    if (!mounted) return;
    setState(() => _saveResult = result);
    if (result.isSuccess && isCreate) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _delete() async {
    final result = await context.read<ChoicesApi>().deleteChoice(
      projectUuid: widget.projectUuid,
      formUuid: widget.formUuid,
      sectionUuid: widget.sectionUuid,
      questionUuid: widget.questionUuid,
      choiceUuid: widget.choiceUuid!,
    );
    if (!mounted) return;
    if (result.isSuccess) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _saveResult = ApiResult.failure(result.errorOrNull!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choice Edit')),
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
                  Text('UUID: ${widget.choiceUuid ?? 'New choice'}'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _labelController,
                    decoration: const InputDecoration(labelText: 'Label'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(labelText: 'Value'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _visibilityConditionController,
                    decoration: const InputDecoration(
                      labelText: 'Visibility condition uuid',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(
                      widget.choiceUuid == null
                          ? 'Create Choice'
                          : 'Save Choice',
                    ),
                  ),
                  if (widget.choiceUuid != null) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _delete,
                      child: const Text('Delete Choice'),
                    ),
                  ],
                  if (_saveResult != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _saveResult!.when(
                        success: (saved) => saved.toString(),
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
