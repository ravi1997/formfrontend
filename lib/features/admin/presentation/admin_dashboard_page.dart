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
              Text(data.toString()),
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
      appBar: AppBar(title: const Text('Admin Dashboard')),
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
              _summaryCard('Config Health', results[0]),
              _summaryCard('Audit Logs', results[1]),
              _summaryCard('Rate Limit Status', results[2]),
            ],
          );
        },
      ),
    );
  }
}
