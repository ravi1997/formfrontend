import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class AdminConfigHealthPage extends StatefulWidget {
  const AdminConfigHealthPage({super.key});

  @override
  State<AdminConfigHealthPage> createState() => _AdminConfigHealthPageState();
}

class _AdminConfigHealthPageState extends State<AdminConfigHealthPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AdminApi>().configHealth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Config Health')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) {
              final status = data['status']?.toString() ?? 'Unknown';
              final checks = data['checks'];
              final checkCount = checks is List ? checks.length : null;
              final warnings = data['warnings'];
              final warningCount = warnings is List ? warnings.length : null;
              final source = data['source']?.toString() ?? 'backend';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Config Health Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Status: $status'),
                          Text('Checks: ${checkCount ?? 'Unknown'}'),
                          Text('Warnings: ${warningCount ?? 'Unknown'}'),
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
                          Text('Config payload', style: Theme.of(context).textTheme.titleMedium),
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
