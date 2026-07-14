import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';

class QuestionDetailPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;
  final String questionUuid;

  const QuestionDetailPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
    required this.questionUuid,
  });

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  String _textOf(dynamic value, [String fallback = 'Unknown']) {
    final text = value?.toString();
    return text == null || text.isEmpty ? fallback : text;
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Detail')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (data) {
              final versions = data['versions'] is List
                  ? data['versions'] as List
                  : const [];
              final choices = data['choices'] is List
                  ? data['choices'] as List
                  : const [];
              final actions = data['actions'] is List
                  ? data['actions'] as List
                  : const [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _textOf(data['label'], 'Unnamed question'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('UUID: ${_textOf(data['uuid'])}'),
                            Text('Type: ${_textOf(data['type'])}'),
                            Text(
                              'Placeholder: ${_textOf(data['placeholder'])}',
                            ),
                            Text(
                              'Description: ${_textOf(data['description'])}',
                            ),
                            Text(
                              'Default value: ${_textOf(data['default_value'])}',
                            ),
                            Text('Help text: ${_textOf(data['help_text'])}'),
                            Text('Tooltip: ${_textOf(data['tooltip'])}'),
                            Text(
                              'Validation conditions: ${_textOf(data['validation_conditions'])}',
                            ),
                            Text(
                              'Visibility conditions: ${_textOf(data['visibility_conditions'])}',
                            ),
                            Text('Add button: ${_textOf(data['add_button'])}'),
                            Text(
                              'Repeatable: ${_textOf(data['is_repeatable'])}',
                            ),
                            Text(
                              'Repeatable condition: ${_textOf(data['repeatable_condition'])}',
                            ),
                            Text(
                              'Check repeat on: ${_textOf(data['check_repeat_on'])}',
                            ),
                            Text(
                              'Min repeatable count: ${_textOf(data['min_repeatable_count'])}',
                            ),
                            Text(
                              'Max repeatable count: ${_textOf(data['max_repeatable_count'])}',
                            ),
                            Text('Is action: ${_textOf(data['isAction'])}'),
                            Text(
                              'Action label: ${_textOf(data['actionLabel'])}',
                            ),
                            Text('Action type: ${_textOf(data['actionType'])}'),
                            Text(
                              'Action button type: ${_textOf(data['actionButtonType'])}',
                            ),
                            Text('Hide button: ${_textOf(data['hideButton'])}'),
                            Text('Action icon: ${_textOf(data['actionIcon'])}'),
                            Text('Tags: ${_textOf(data['tags'])}'),
                            Text('Choices: ${choices.length}'),
                            Text('Actions: ${actions.length}'),
                            Text('Versions: ${versions.length}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(data.toString()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        RouteNames.questionEdit,
                        arguments: {
                          'projectUuid': widget.projectUuid,
                          'formUuid': widget.formUuid,
                          'sectionUuid': widget.sectionUuid,
                          'questionUuid': widget.questionUuid,
                        },
                      ),
                      child: const Text('Edit Question'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Choices',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...choices.map(
                      (choice) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(choice.toString()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...actions.map(
                      (action) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(action.toString()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Versions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...versions.map(
                      (version) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(version.toString()),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
