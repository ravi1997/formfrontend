import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectUuid;

  const ProjectDetailPage({super.key, required this.projectUuid});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ProjectsApi>().getProject(widget.projectUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Detail')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (data) {
              final name = data['name']?.toString() ?? 'Unnamed project';
              final status = data['status']?.toString() ?? 'Unknown';
              final versionCount = data['versions'] is List
                  ? (data['versions'] as List).length
                  : null;
              final owner =
                  data['owner']?.toString() ??
                  data['created_by']?.toString() ??
                  'Unknown';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
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
                      RouteNames.projectForm,
                      arguments: {'projectUuid': widget.projectUuid},
                    ),
                    child: const Text('Edit Project'),
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
