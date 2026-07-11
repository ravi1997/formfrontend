import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';

class FormsListPage extends StatefulWidget {
  const FormsListPage({super.key});

  @override
  State<FormsListPage> createState() => _FormsListPageState();
}

class _FormsListPageState extends State<FormsListPage> {
  late Future<ApiResult<List<dynamic>>> _projectsFuture;
  String? _selectedProjectUuid;
  late Future<ApiResult<List<dynamic>>>? _formsFuture;
  final _createFormNameController = TextEditingController();
  final _editFormNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ProjectsApi>().listProjects();
    _formsFuture = null;
  }

  @override
  void dispose() {
    _createFormNameController.dispose();
    _editFormNameController.dispose();
    super.dispose();
  }

  Future<void> _loadForms(String projectUuid) async {
    setState(() {
      _selectedProjectUuid = projectUuid;
      _formsFuture = context.read<FormsApi>().listForms(projectUuid);
    });
    await _formsFuture;
  }

  Future<void> _createForm() async {
    final projectUuid = _selectedProjectUuid;
    final name = _createFormNameController.text.trim();
    if (projectUuid == null || name.isEmpty) return;
    final result = await context.read<FormsApi>().createForm(projectUuid, {'name': name});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Form created' : result.errorOrNull?.message ?? 'Create failed'),
        ),
      );
    }
    if (result.isSuccess) {
      _createFormNameController.clear();
      await _loadForms(projectUuid);
    }
  }

  Future<void> _updateForm(String formUuid, String currentName) async {
    final projectUuid = _selectedProjectUuid;
    if (projectUuid == null) return;
    final formsApi = context.read<FormsApi>();
    _editFormNameController.text = currentName;
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit form'),
        content: TextField(
          controller: _editFormNameController,
          decoration: const InputDecoration(labelText: 'Form name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, _editFormNameController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final result = await formsApi.updateForm(projectUuid, formUuid, {'name': name});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Form updated' : result.errorOrNull?.message ?? 'Update failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _loadForms(projectUuid);
    }
  }

  Future<void> _deleteForm(String formUuid) async {
    final projectUuid = _selectedProjectUuid;
    if (projectUuid == null) return;
    final formsApi = context.read<FormsApi>();
    final result = await formsApi.deleteForm(projectUuid, formUuid);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Form deleted' : result.errorOrNull?.message ?? 'Delete failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _loadForms(projectUuid);
    }
  }

  String _labelFor(dynamic item) {
    if (item is Map<String, dynamic>) {
      return (item['name'] ?? item['title'] ?? item['slug'] ?? item['uuid'] ?? item['id'] ?? 'Unnamed form').toString();
    }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _selectedProjectUuid == null
                ? null
                : () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Create form'),
                        content: TextField(
                          controller: _createFormNameController,
                          decoration: const InputDecoration(labelText: 'Form name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(dialogContext);
                              await _createForm();
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
      body: FutureBuilder<ApiResult<List<dynamic>>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (projects) {
              if (projects.isEmpty) {
                return const Center(child: Text('No projects available'));
              }

              final selectedProjectUuid = _selectedProjectUuid ??
                  (projects.first is Map<String, dynamic>
                      ? (projects.first['uuid'] ?? projects.first['id'] ?? '').toString()
                      : projects.first.toString());

              _formsFuture ??= context.read<FormsApi>().listForms(selectedProjectUuid);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedProjectUuid,
                      items: projects
                          .map(
                            (project) => DropdownMenuItem<String>(
                              value: project is Map<String, dynamic>
                                  ? (project['uuid'] ?? project['id'] ?? '').toString()
                                  : project.toString(),
                              child: Text(_labelFor(project)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _loadForms(value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Project'),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _formsFuture,
                      builder: (context, formsSnapshot) {
                        if (!formsSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return formsSnapshot.data!.when(
                          success: (forms) => RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                _formsFuture = context.read<FormsApi>().listForms(selectedProjectUuid);
                              });
                              await _formsFuture;
                            },
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: forms.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final form = forms[index];
                                final formUuid = form is Map<String, dynamic>
                                    ? (form['uuid'] ?? form['id'] ?? '').toString()
                                    : '';
                                return ListTile(
                                  leading: const Icon(Icons.description_outlined),
                                  title: Text(_labelFor(form)),
                                  subtitle: Text(form is Map<String, dynamic>
                                      ? (form['uuid'] ?? form['id'] ?? '').toString()
                                      : ''),
                                  onTap: formUuid.isEmpty
                                      ? null
                                      : () => Navigator.of(context).pushNamed(
                                            RouteNames.formDetail,
                                            arguments: {
                                              'projectUuid': selectedProjectUuid,
                                              'formUuid': formUuid,
                                            },
                                          ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _updateForm(formUuid, _labelFor(form));
                                      } else if (value == 'delete') {
                                        _deleteForm(formUuid);
                                      } else if (value == 'versions') {
                                        Navigator.of(context).pushNamed(
                                          RouteNames.formVersions,
                                          arguments: {
                                            'projectUuid': selectedProjectUuid,
                                            'formUuid': formUuid,
                                          },
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                                      PopupMenuItem(value: 'versions', child: Text('Versions')),
                                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          failure: (error) => Center(child: Text(error.message)),
                        );
                      },
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
