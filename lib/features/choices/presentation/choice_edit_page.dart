import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';

class ChoiceEditPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;
  final String questionUuid;
  final String choiceUuid;

  const ChoiceEditPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
    required this.questionUuid,
    required this.choiceUuid,
  });

  @override
  State<ChoiceEditPage> createState() => _ChoiceEditPageState();
}

class _ChoiceEditPageState extends State<ChoiceEditPage> {
  late Future<ApiResult<List<dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ChoicesApi>().listChoices(
          projectUuid: widget.projectUuid,
          formUuid: widget.formUuid,
          sectionUuid: widget.sectionUuid,
          questionUuid: widget.questionUuid,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choice Edit')),
      body: FutureBuilder<ApiResult<List<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return snapshot.data!.when(
            success: (choices) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choice Editor', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Choice count: ${choices.length}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...choices.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Choice ${entry.key + 1}', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Type: ${entry.value.runtimeType}'),
                            const SizedBox(height: 8),
                            SelectableText(entry.value.toString()),
                          ],
                        ),
                      ),
                    ),
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
