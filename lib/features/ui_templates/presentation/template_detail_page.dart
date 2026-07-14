import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';

class TemplateDetailPage extends StatefulWidget {
  final String templateUuid;
  final bool isThemeTemplate;

  const TemplateDetailPage({
    super.key,
    required this.templateUuid,
    required this.isThemeTemplate,
  });

  const TemplateDetailPage.theme({
    super.key,
    required this.templateUuid,
  }) : isThemeTemplate = true;

  const TemplateDetailPage.layout({
    super.key,
    required this.templateUuid,
  }) : isThemeTemplate = false;

  @override
  State<TemplateDetailPage> createState() => _TemplateDetailPageState();
}

class _TemplateDetailPageState extends State<TemplateDetailPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    final api = context.read<UiTemplatesApi>();
    _future = widget.isThemeTemplate ? api.getThemeTemplate(widget.templateUuid) : api.getLayoutTemplate(widget.templateUuid);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isThemeTemplate ? 'Theme Template Detail' : 'Layout Template Detail';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final result = snapshot.data!;
          return result.when(
            success: (data) {
              final name = data['name']?.toString() ?? data['title']?.toString() ?? 'Unnamed template';
              final version = data['revision']?.toString() ?? data['version']?.toString() ?? 'Unknown';
              final status = data['status']?.toString() ?? 'Unknown';
              final kind = widget.isThemeTemplate ? 'Theme' : 'Layout';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$kind Template Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Name: $name'),
                          Text('Version: $version'),
                          Text('Status: $status'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SelectableText(data.toString()),
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
