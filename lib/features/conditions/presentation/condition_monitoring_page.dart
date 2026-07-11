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
            success: (data) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(data.toString()),
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
