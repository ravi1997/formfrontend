import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class AdminAuditLogsPage extends StatefulWidget {
  const AdminAuditLogsPage({super.key});

  @override
  State<AdminAuditLogsPage> createState() => _AdminAuditLogsPageState();
}

class _AdminAuditLogsPageState extends State<AdminAuditLogsPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AdminApi>().auditLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Logs')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) {
              final logs = data is List
                  ? data
                  : data is Map<String, dynamic>
                      ? (data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? data['results'] as List<dynamic>? ?? const <dynamic>[])
                      : data is Map
                          ? (Map<String, dynamic>.from(data)['items'] as List<dynamic>? ??
                              Map<String, dynamic>.from(data)['data'] as List<dynamic>? ??
                              Map<String, dynamic>.from(data)['results'] as List<dynamic>? ??
                              const <dynamic>[])
                          : const <dynamic>[];
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final entry = log is Map<String, dynamic> ? log : <String, dynamic>{'message': log.toString()};
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry['message']?.toString() ?? entry['action']?.toString() ?? 'Audit entry',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text('Actor: ${entry['actor']?.toString() ?? entry['user']?.toString() ?? 'Unknown'}'),
                          Text('Target: ${entry['target']?.toString() ?? entry['resource']?.toString() ?? 'Unknown'}'),
                          Text('Time: ${entry['created_at']?.toString() ?? entry['timestamp']?.toString() ?? 'Unknown'}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
