import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<List<ApiResult<dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    final api = context.read<AdminApi>();
    _future = Future.wait([
      api.configHealth(),
      api.auditLogs(),
      api.rateLimitStatus(),
    ]);
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  Widget _summaryCard(String title, ApiResult<dynamic> result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: result.when(
          success: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (title == 'Config Health') ...[
                Text('Status: ${_asMap(data)?['status']?.toString() ?? 'Unknown'}'),
              ] else if (title == 'Audit Logs') ...[
                Text('Entries: ${(data is List ? data.length : 0)}'),
              ] else if (title == 'Rate Limit Status') ...[
                Text('Status: ${_asMap(data)?['status']?.toString() ?? 'Unknown'}'),
              ],
              const SizedBox(height: 8),
              if (title == 'Config Health') ...[
                Text('Checks: ${_asMap(data)?['checks'] is List ? (_asMap(data)?['checks'] as List).length : 'Unknown'}'),
              ] else if (title == 'Audit Logs') ...[
                Text('Latest entry type: ${data is List && data.isNotEmpty ? data.first.runtimeType : 'Unknown'}'),
              ] else if (title == 'Rate Limit Status') ...[
                Text('Fields: ${_asMap(data)?.length ?? 'Unknown'}'),
              ],
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

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: FutureBuilder<List<ApiResult<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final results = snapshot.data!;
          final configHealth = results[0];
          final auditLogs = results[1];
          final rateLimitStatus = results[2];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _statusChip(
                    configHealth.isSuccess ? 'Config healthy' : 'Config error',
                    configHealth.isSuccess ? Colors.green : Colors.red,
                  ),
                  _statusChip(
                    auditLogs.isSuccess ? 'Audit logs loaded' : 'Audit logs error',
                    auditLogs.isSuccess ? Colors.green : Colors.red,
                  ),
                  _statusChip(
                    rateLimitStatus.isSuccess ? 'Rate limits loaded' : 'Rate limits error',
                    rateLimitStatus.isSuccess ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _summaryCard('Config Health', configHealth),
              _summaryCard('Audit Logs', auditLogs),
              _summaryCard('Rate Limit Status', rateLimitStatus),
            ],
          );
        },
      ),
    );
  }
}
