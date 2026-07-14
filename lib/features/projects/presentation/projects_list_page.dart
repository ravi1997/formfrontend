import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';

class ProjectsListPage extends StatefulWidget {
  const ProjectsListPage({super.key});

  @override
  State<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  late Future<ApiResult<List<dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ProjectsApi>().listProjects();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = context.read<ProjectsApi>().listProjects();
    });
    await _future;
  }

  Future<void> _deleteProject(String projectUuid) async {
    final projectsApi = context.read<ProjectsApi>();
    final result = await projectsApi.deleteProject(projectUuid);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? 'Project deleted'
              : result.errorOrNull?.message ?? 'Delete failed',
        ),
      ),
    );
    if (result.isSuccess) {
      await _refresh();
    }
  }

  String _labelFor(dynamic item) {
    if (item is Map<String, dynamic>) {
      return (item['name'] ??
              item['title'] ??
              item['slug'] ??
              item['uuid'] ??
              item['id'] ??
              'Unnamed project')
          .toString();
    }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteNames.projectForm),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<ApiResult<List<dynamic>>>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final result = snapshot.data!;
            return result.when(
              success: (projects) => ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: projects.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final project = projects[index];
                  final uuid = project is Map<String, dynamic>
                      ? (project['uuid'] ?? project['id'] ?? '').toString()
                      : '';
                  return ListTile(
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(_labelFor(project)),
                    subtitle: Text(uuid),
                    onTap: uuid.isEmpty
                        ? null
                        : () => Navigator.of(context).pushNamed(
                            RouteNames.projectDetail,
                            arguments: uuid,
                          ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.of(context).pushNamed(
                            RouteNames.projectForm,
                            arguments: {'projectUuid': uuid},
                          );
                        } else if (value == 'delete') {
                          _deleteProject(uuid);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  );
                },
              ),
              failure: (error) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Center(child: Text(error.message)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
