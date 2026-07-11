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
  final _createNameController = TextEditingController();
  final _editNameController = TextEditingController();

  @override
  void dispose() {
    _createNameController.dispose();
    _editNameController.dispose();
    super.dispose();
  }

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

  Future<void> _createProject() async {
    final name = _createNameController.text.trim();
    if (name.isEmpty) return;
    final result = await context.read<ProjectsApi>().createProject({'name': name});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Project created' : result.errorOrNull?.message ?? 'Create failed'),
        ),
      );
    }
    if (result.isSuccess) {
      _createNameController.clear();
      await _refresh();
    }
  }

  Future<void> _updateProject(String projectUuid, String currentName) async {
    final projectsApi = context.read<ProjectsApi>();
    _editNameController.text = currentName;
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit project'),
        content: TextField(
          controller: _editNameController,
          decoration: const InputDecoration(labelText: 'Project name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, _editNameController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final result = await projectsApi.updateProject(projectUuid, {'name': name});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Project updated' : result.errorOrNull?.message ?? 'Update failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _refresh();
    }
  }

  Future<void> _deleteProject(String projectUuid) async {
    final projectsApi = context.read<ProjectsApi>();
    final result = await projectsApi.deleteProject(projectUuid);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Project deleted' : result.errorOrNull?.message ?? 'Delete failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _refresh();
    }
  }

  String _labelFor(dynamic item) {
    if (item is Map<String, dynamic>) {
      return (item['name'] ?? item['title'] ?? item['slug'] ?? item['uuid'] ?? item['id'] ?? 'Unnamed project').toString();
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
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Create project'),
                  content: TextField(
                    controller: _createNameController,
                    decoration: const InputDecoration(labelText: 'Project name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await _createProject();
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
              );
            },
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
                          _updateProject(uuid, _labelFor(project));
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
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
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
