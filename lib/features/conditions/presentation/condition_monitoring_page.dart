import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';

class ConditionMonitoringPage extends StatefulWidget {
  const ConditionMonitoringPage({super.key});

  @override
  State<ConditionMonitoringPage> createState() => _ConditionMonitoringPageState();
}

class _ConditionMonitoringPageState extends State<ConditionMonitoringPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ConditionsApi>().monitoringGraph();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condition Monitoring')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (data) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monitoring Summary', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Graph fields: ${(data['graph'] is Map ? (data['graph'] as Map).length : data['nodes'] != null ? 1 : 0)}'),
                        Text('Evaluation fields: ${(data['evaluation_stats'] is Map ? (data['evaluation_stats'] as Map).length : data['stats'] is Map ? (data['stats'] as Map).length : 0)}'),
                        Text('Heatmap present: ${data['heatmap'] != null ? 'yes' : 'no'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(title: 'Graph Snapshot', value: data['graph'] ?? data['nodes'] ?? data),
                const SizedBox(height: 12),
                _SectionCard(title: 'Evaluation Stats', value: data['evaluation_stats'] ?? data['stats']),
                const SizedBox(height: 12),
                _SectionCard(title: 'Heatmap', value: data['heatmap']),
                const SizedBox(height: 12),
                _SectionCard(title: 'Unused Conditions', value: data['unused']),
                const SizedBox(height: 12),
                _SectionCard(title: 'Most Used', value: data['most_used']),
              ],
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Object? value;

  const _SectionCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(value?.toString() ?? 'No data'),
          ],
        ),
      ),
    );
  }
}
