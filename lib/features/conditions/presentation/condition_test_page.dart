import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/conditions/presentation/condition_monitoring_page.dart';
import 'package:formfrontend/features/conditions/presentation/condition_presets_page.dart';

class ConditionTestPage extends StatefulWidget {
  const ConditionTestPage({super.key});

  @override
  State<ConditionTestPage> createState() => _ConditionTestPageState();
}

class _ConditionTestPageState extends State<ConditionTestPage> {
  late Future<List<ApiResult<dynamic>>> _future;
  final _payloadController = TextEditingController(text: '{"condition":"sample"}');
  ApiResult<Map<String, dynamic>>? _testResult;

  @override
  void initState() {
    super.initState();
    final api = context.read<ConditionsApi>();
    _future = Future.wait([
      api.metadata(),
      api.operatorsMetadata(),
      api.presets(),
    ]);
  }

  @override
  void dispose() {
    _payloadController.dispose();
    super.dispose();
  }

  Future<void> _runTest() async {
    final result = await context.read<ConditionsApi>().testCondition({
      'payload': _payloadController.text.trim(),
    });
    if (!mounted) return;
    setState(() {
      _testResult = result;
    });
  }

  Widget _resultCard(String title, ApiResult<dynamic> result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: result.when(
          success: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (title == 'Metadata')
                Text('Keys: ${(data is Map ? data.keys.length : 0)}')
              else if (title == 'Operators')
                Text('Keys: ${(data is Map ? data.keys.length : 0)}')
              else if (title == 'Presets')
                Text('Keys: ${(data is Map ? data.keys.length : 0)}'),
              const SizedBox(height: 8),
              SelectableText(data.toString()),
            ],
          ),
          failure: (error) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(error.message),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conditions')),
      body: FutureBuilder<List<ApiResult<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final results = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Condition Test'),
                      SizedBox(height: 8),
                      Text('Use metadata, operator metadata, and presets to assemble test payloads before posting to /conditions/test.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _resultCard('Metadata', results[0]),
              _resultCard('Operators', results[1]),
              _resultCard('Presets', results[2]),
              if (_testResult != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _testResult!.when(
                      success: (data) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Test Result', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Passed: ${data['passed']?.toString() ?? 'Unknown'}'),
                          const SizedBox(height: 8),
                          SelectableText(data.toString()),
                        ],
                      ),
                      failure: (error) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Test Result', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(error.message),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ConditionMonitoringPage()),
                    ),
                    child: const Text('Monitoring'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ConditionPresetsPage()),
                    ),
                    child: const Text('Presets'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _payloadController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Test payload',
                  helperText: 'Posted to /conditions/test',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _runTest,
                child: const Text('Run Test'),
              ),
            ],
          );
        },
      ),
    );
  }
}
