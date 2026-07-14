import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return snapshot.data!.when(
            success: (data) {
              final label = data['label']?.toString() ?? data['name']?.toString() ?? 'Unnamed question';
              final type = data['type']?.toString() ?? 'Unknown';
              final requiredValue = data['required'];
              final choiceCount = data['choices'] is List ? (data['choices'] as List).length : null;

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
                            Text(label, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Type: $type'),
                            Text('Required: ${requiredValue ?? 'Unknown'}'),
                            Text('Choices: ${choiceCount ?? 'Unknown'}'),
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
