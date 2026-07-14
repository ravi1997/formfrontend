import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';

class FormDetailPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;

  const FormDetailPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
  });

  @override
  State<FormDetailPage> createState() => _FormDetailPageState();
}

class _FormDetailPageState extends State<FormDetailPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<FormsApi>().getForm(widget.projectUuid, widget.formUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Detail')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (data) {
              final name = data['name']?.toString() ?? 'Unnamed form';
              final status = data['status']?.toString() ?? 'Unknown';
              final versionCount = data['versions'] is List ? (data['versions'] as List).length : null;
              final owner = data['owner']?.toString() ?? data['created_by']?.toString() ?? 'Unknown';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Status: $status'),
                            Text('Owner: $owner'),
                            Text('Versions: ${versionCount ?? 'Unknown'}'),
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        RouteNames.formEdit,
                        arguments: {
                          'projectUuid': widget.projectUuid,
                          'formUuid': widget.formUuid,
                        },
                      ),
                      child: const Text('Edit Form'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        RouteNames.formEffectiveUi,
                        arguments: {
                          'projectUuid': widget.projectUuid,
                          'formUuid': widget.formUuid,
                        },
                      ),
                      child: const Text('Open Effective UI'),
                    ),
                  ],
                ),
              );
            },
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
