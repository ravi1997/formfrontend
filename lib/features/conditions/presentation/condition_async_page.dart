import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';

class ConditionAsyncPage extends StatefulWidget {
  const ConditionAsyncPage({super.key});

  @override
  State<ConditionAsyncPage> createState() => _ConditionAsyncPageState();
}

class _ConditionAsyncPageState extends State<ConditionAsyncPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ConditionsApi>().metadata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condition Async')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) {
              final status = data['status']?.toString() ?? 'Unknown';
              final jobId = data['job_id']?.toString() ?? data['id']?.toString() ?? 'Unknown';
              final eta = data['eta']?.toString() ?? data['estimated_time']?.toString() ?? 'Unknown';
              final resultValue = data['result']?.toString() ?? data['value']?.toString() ?? 'Unknown';
              final progress = data['progress']?.toString() ?? data['percent']?.toString() ?? 'Unknown';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Async Job Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Job ID: $jobId'),
                          Text('Status: $status'),
                          Text('ETA: $eta'),
                          Text('Progress: $progress'),
                          Text('Result: $resultValue'),
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
                          Text('Async actions', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          const Text('Submit a job to /conditions/async/evaluate and poll /conditions/async/<job_id>.'),
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
                          Text('Async payload', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          SelectableText(data.toString()),
                        ],
                      ),
                    ),
                  ),
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
