import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';

class ConditionVersionsPage extends StatefulWidget {
  const ConditionVersionsPage({super.key});

  @override
  State<ConditionVersionsPage> createState() => _ConditionVersionsPageState();
}

class _ConditionVersionsPageState extends State<ConditionVersionsPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ConditionsApi>().metadata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condition Versions')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) {
              final versions = data['versions'];
              final versionList = versions is List ? versions : const [];
              final current = data['current_version']?.toString() ?? data['version']?.toString() ?? 'Unknown';
              final recorded = data['recorded']?.toString() ?? data['history_count']?.toString() ?? 'Unknown';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Version Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Current version: $current'),
                          Text('Recorded versions: ${versionList.length}'),
                          Text('Recorded count: $recorded'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (versionList.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Version history', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            ...versionList.take(3).map((version) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(version.toString()),
                                )),
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
                          Text('Version payload', style: Theme.of(context).textTheme.titleMedium),
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
