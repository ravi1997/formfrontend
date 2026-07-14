import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class AdminRateLimitsPage extends StatefulWidget {
  const AdminRateLimitsPage({super.key});

  @override
  State<AdminRateLimitsPage> createState() => _AdminRateLimitsPageState();
}

class _AdminRateLimitsPageState extends State<AdminRateLimitsPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AdminApi>().rateLimitStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Limits')),
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
              final entries = payload.entries.toList();
              final status = payload['status']?.toString() ?? 'Unknown';
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _StatusBanner(
                    title: 'Rate limit status',
                    subtitle: entries.isEmpty ? 'No structured data returned' : '$status · ${entries.length} fields returned',
                  ),
                  const SizedBox(height: 16),
                  ...entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.key, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text('Type: ${entry.value.runtimeType}'),
                              const SizedBox(height: 8),
                              SelectableText(entry.value.toString()),
                            ],
                          ),
                        ),
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

class _StatusBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatusBanner({
    required this.title,
    required this.subtitle,
  });

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
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}
