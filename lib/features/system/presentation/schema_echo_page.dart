import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/system/data/system_api.dart';

class SchemaEchoPage extends StatefulWidget {
  const SchemaEchoPage({super.key});

  @override
  State<SchemaEchoPage> createState() => _SchemaEchoPageState();
}

class _SchemaEchoPageState extends State<SchemaEchoPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<SystemApi>().schemaEcho();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schema Echo')),
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
              final echo = payload['echo'] ?? payload['data'];
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
                          Text('Schema Echo Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Status: $status'),
                          Text('Echo present: ${echo != null ? 'yes' : 'no'}'),
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
                          Text('Schema payload', style: Theme.of(context).textTheme.titleMedium),
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
