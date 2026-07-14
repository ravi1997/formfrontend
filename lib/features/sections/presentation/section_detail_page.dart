import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';

class SectionDetailPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;

  const SectionDetailPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
  });

  @override
  State<SectionDetailPage> createState() => _SectionDetailPageState();
}

class _SectionDetailPageState extends State<SectionDetailPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  String _textOf(dynamic value, [String fallback = 'Unknown']) {
    final text = value?.toString();
    return text == null || text.isEmpty ? fallback : text;
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Section Detail')),
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
                              _textOf(data['title'], 'Unnamed section'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('UUID: ${_textOf(data['uuid'])}'),
                            Text('Status: ${_textOf(data['status'])}'),
                            Text(
                              'Description: ${_textOf(data['description'])}',
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
                            Text('Deleted: ${_textOf(data['isDeleted'])}'),
                            Text(
                              'Visibility condition: ${_textOf(data['visibility_condition'])}',
                            ),
                            Text(
                              'Validation conditions: ${_textOf(data['validation_conditions'])}',
                            ),
                            Text('Tags: ${_textOf(data['tags'])}'),
                            Text('Icon: ${_textOf(data['icon'])}'),
                            Text('Questions: ${_textOf(data['questions'])}'),
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
                        RouteNames.sectionEdit,
                        arguments: {
                          'projectUuid': widget.projectUuid,
                          'formUuid': widget.formUuid,
                          'sectionUuid': widget.sectionUuid,
                        },
                      ),
                      child: const Text('Edit Section'),
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
