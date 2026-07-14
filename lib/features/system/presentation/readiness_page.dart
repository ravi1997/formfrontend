import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/system/data/system_api.dart';

class ReadinessPage extends StatefulWidget {
  const ReadinessPage({super.key});

  @override
  State<ReadinessPage> createState() => _ReadinessPageState();
}

class _ReadinessPageState extends State<ReadinessPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<SystemApi>().readiness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Readiness')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) {
              final payload = data is Map<String, dynamic>
                  ? data
                  : data is Map
                      ? Map<String, dynamic>.from(data)
                      : <String, dynamic>{};
              final status = payload['status']?.toString() ?? 'Unknown';
              final checks = payload['checks'];
              final checkCount = checks is List ? checks.length : null;
              final source = payload['source']?.toString() ?? 'backend';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Readiness Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Status: $status'),
                          Text('Checks: ${checkCount ?? 'Unknown'}'),
                          Text('Source: $source'),
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
                          Text('Readiness payload', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          SelectableText(payload.toString()),
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
