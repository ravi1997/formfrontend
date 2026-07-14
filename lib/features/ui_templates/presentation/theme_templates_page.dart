import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';

class ThemeTemplatesPage extends StatefulWidget {
  const ThemeTemplatesPage({super.key});

  @override
  State<ThemeTemplatesPage> createState() => _ThemeTemplatesPageState();
}

class _ThemeTemplatesPageState extends State<ThemeTemplatesPage> {
  late Future<ApiResult<List<dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<UiTemplatesApi>().listThemeTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(RouteNames.themeTemplateEdit),
          ),
        ],
      ),
      body: FutureBuilder<ApiResult<List<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return snapshot.data!.when(
            success: (templates) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme Templates', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Template count: ${templates.length}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...templates.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Template ${entry.key + 1}', style: Theme.of(context).textTheme.titleMedium),
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
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
