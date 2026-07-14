import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';

class ConditionPresetsPage extends StatefulWidget {
  const ConditionPresetsPage({super.key});

  @override
  State<ConditionPresetsPage> createState() => _ConditionPresetsPageState();
}

class _ConditionPresetsPageState extends State<ConditionPresetsPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ConditionsApi>().presets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condition Presets')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (data) {
              final presets = data['presets'];
              final presetList = presets is List ? presets : const [];
              final presetCount = presetList.length;
              final importSupport = data['import_supported']?.toString() ?? 'Unknown';
              final exportSupport = data['export_supported']?.toString() ?? 'Unknown';
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
                          Text('Preset Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Preset count: $presetCount'),
                          Text('Import supported: $importSupport'),
                          Text('Export supported: $exportSupport'),
                          Text('Source: $source'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (presetList.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('First preset', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            SelectableText(presetList.first.toString()),
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
                          Text('Preset payload', style: Theme.of(context).textTheme.titleMedium),
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
