import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';

class FormDetailPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;

  const FormDetailPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
  });

  @override
  State<FormDetailPage> createState() => _FormDetailPageState();
}

class _FormDetailPageState extends State<FormDetailPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  String _textOf(dynamic value, [String fallback = 'Unknown']) {
    final text = value?.toString();
    return text == null || text.isEmpty ? fallback : text;
  }

  @override
  void initState() {
    super.initState();
    _future = context.read<FormsApi>().getForm(
      widget.projectUuid,
      widget.formUuid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Detail')),
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
              final workflowHistory = data['workflow_history'] is List
                  ? data['workflow_history'] as List
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
                              _textOf(data['name'], 'Unnamed form'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('UUID: ${_textOf(data['uuid'])}'),
                            Text('Status: ${_textOf(data['status'])}'),
                            Text('Created at: ${_textOf(data['created_at'])}'),
                            Text('Updated at: ${_textOf(data['updated_at'])}'),
                            Text('Editors: ${_textOf(data['editors'])}'),
                            Text('Viewers: ${_textOf(data['viewers'])}'),
                            Text('Reviewers: ${_textOf(data['reviewers'])}'),
                            Text('Approvers: ${_textOf(data['approvers'])}'),
                            Text('Submitters: ${_textOf(data['submitters'])}'),
                            Text(
                              'Requires reviewer: ${_textOf(data['requires_reviewer'])}',
                            ),
                            Text(
                              'Requires approver: ${_textOf(data['requires_approver'])}',
                            ),
                            Text(
                              'Min reviewers required: ${_textOf(data['min_reviewers_required'])}',
                            ),
                            Text(
                              'Min approvers required: ${_textOf(data['min_approvers_required'])}',
                            ),
                            Text(
                              'Validation conditions: ${_textOf(data['validation_conditions'])}',
                            ),
                            Text(
                              'Child sections: ${_textOf(data['child_sections'])}',
                            ),
                            Text('Tags: ${_textOf(data['tags'])}'),
                            Text('Icon: ${_textOf(data['icon'])}'),
                            Text('Public: ${_textOf(data['is_public'])}'),
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
                        RouteNames.formEdit,
                        arguments: {
                          'projectUuid': widget.projectUuid,
                          'formUuid': widget.formUuid,
                        },
                      ),
                      child: const Text('Edit Form'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        RouteNames.formEffectiveUi,
                        arguments: {
                          'projectUuid': widget.projectUuid,
                          'formUuid': widget.formUuid,
                        },
                      ),
                      child: const Text('Open Effective UI'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Workflow history',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...workflowHistory.map(
                      (event) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(event.toString()),
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
