import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';

class ConditionBatchTestPage extends StatefulWidget {
  const ConditionBatchTestPage({super.key});

  @override
  State<ConditionBatchTestPage> createState() => _ConditionBatchTestPageState();
}

class _ConditionBatchTestPageState extends State<ConditionBatchTestPage> {
  final _payloadController = TextEditingController(text: '{"batch":[{"condition":"sample"}]}');
  ApiResult<Map<String, dynamic>>? _result;

  @override
  void dispose() {
    _payloadController.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final result = await context.read<ConditionsApi>().testBatchConditions({
      'payload': _payloadController.text.trim(),
    });
    if (!mounted) return;
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condition Batch Test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Batch payload', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _payloadController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      helperText: 'Posted to /conditions/test/batch',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Batch response', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(_result == null ? 'No batch response yet' : 'Batch response received'),
                  if (_result != null) ...[
                    const SizedBox(height: 8),
                    _result!.when(
                      success: (data) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keys: ${data.keys.join(', ')}'),
                          const SizedBox(height: 8),
                          SelectableText(data.toString()),
                        ],
                      ),
                      failure: (error) => Text(error.message),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _run,
            child: const Text('Run Batch Test'),
          ),
        ],
      ),
    );
  }
}
