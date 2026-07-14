import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';

class QuestionVersionsPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;
  final String questionUuid;

  const QuestionVersionsPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
    required this.questionUuid,
  });

  @override
  State<QuestionVersionsPage> createState() => _QuestionVersionsPageState();
}

class _QuestionVersionsPageState extends State<QuestionVersionsPage> {
  late Future<ApiResult<List<dynamic>>> _future;

  String _textOf(dynamic value, [String fallback = 'Unknown']) {
    final text = value?.toString();
    return text == null || text.isEmpty ? fallback : text;
  }

  Widget _versionCard(dynamic version, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version ${index + 1}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('UUID: ${_textOf(version is Map ? version['uuid'] : null)}'),
            Text(
              'Status: ${_textOf(version is Map ? version['status'] : null)}',
            ),
            Text(
              'Created: ${_textOf(version is Map ? version['created'] : null)}',
            ),
            Text(
              'Created by: ${_textOf(version is Map ? version['created_by'] : null)}',
            ),
            Text(
              'Updated: ${_textOf(version is Map ? version['updated'] : null)}',
            ),
            Text(
              'Updated by: ${_textOf(version is Map ? version['updated_by'] : null)}',
            ),
            const SizedBox(height: 8),
            SelectableText(version.toString()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _future = context.read<QuestionsApi>().listQuestionVersions(
      projectUuid: widget.projectUuid,
      formUuid: widget.formUuid,
      sectionUuid: widget.sectionUuid,
      questionUuid: widget.questionUuid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Versions')),
      body: FutureBuilder<ApiResult<List<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (versions) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question Versions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Version count: ${versions.length}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...versions.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _versionCard(entry.value, entry.key),
                  ),
                ),
              ],
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
