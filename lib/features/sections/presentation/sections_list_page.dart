import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';

class SectionsListPage extends StatefulWidget {
  const SectionsListPage({super.key});

  @override
  State<SectionsListPage> createState() => _SectionsListPageState();
}

class _SectionsListPageState extends State<SectionsListPage> {
  late Future<ApiResult<List<dynamic>>> _projectsFuture;
  String? _projectUuid;
  String? _formUuid;
  Future<ApiResult<List<dynamic>>>? _sectionsFuture;
  Future<ApiResult<List<dynamic>>>? _formsFuture;
  final _editSectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ProjectsApi>().listProjects();
  }

  @override
  void dispose() {
    _editSectionController.dispose();
    super.dispose();
  }

  String _labelFor(dynamic item, {String fallback = 'Unnamed'}) {
    if (item is Map<String, dynamic>) {
      return (item['name'] ?? item['title'] ?? item['slug'] ?? item['uuid'] ?? item['id'] ?? fallback).toString();
    }
    return item.toString();
  }

  String _uuidFor(dynamic item) {
    if (item is Map<String, dynamic>) {
      return (item['uuid'] ?? item['id'] ?? '').toString();
    }
    return item.toString();
  }

  Future<void> _loadForms(String projectUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = null;
      _formsFuture = context.read<FormsApi>().listForms(projectUuid);
      _sectionsFuture = null;
    });
    await _formsFuture;
  }

  Future<void> _loadSections(String projectUuid, String formUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionsFuture = context.read<SectionsApi>().listSections(
        projectUuid: projectUuid,
        formUuid: formUuid,
      );
    });
    await _sectionsFuture;
  }

  Future<void> _updateSection(String sectionUuid, String currentName) async {
    final projectUuid = _projectUuid;
    final formUuid = _formUuid;
    if (projectUuid == null || formUuid == null) return;
    final sectionsApi = context.read<SectionsApi>();
    _editSectionController.text = currentName;
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit section'),
        content: TextField(
          controller: _editSectionController,
          decoration: const InputDecoration(labelText: 'Section name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, _editSectionController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final result = await sectionsApi.updateSection(
      projectUuid: projectUuid,
      formUuid: formUuid,
      sectionUuid: sectionUuid,
      payload: {'name': name},
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Section updated' : result.errorOrNull?.message ?? 'Update failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _loadSections(projectUuid, formUuid);
    }
  }

  Future<void> _deleteSection(String sectionUuid) async {
    final projectUuid = _projectUuid;
    final formUuid = _formUuid;
    if (projectUuid == null || formUuid == null) return;
    final sectionsApi = context.read<SectionsApi>();
    final result = await sectionsApi.deleteSection(
      projectUuid: projectUuid,
      formUuid: formUuid,
      sectionUuid: sectionUuid,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Section deleted' : result.errorOrNull?.message ?? 'Delete failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _loadSections(projectUuid, formUuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sections')),
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

              _projectUuid ??= _uuidFor(projects.first);
              _formsFuture ??= context.read<FormsApi>().listForms(_projectUuid!);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      initialValue: _projectUuid,
                      decoration: const InputDecoration(labelText: 'Project'),
                      items: projects
                          .map((project) => DropdownMenuItem<String>(
                                value: _uuidFor(project),
                                child: Text(_labelFor(project, fallback: 'Project')),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _loadForms(value);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _formsFuture,
                      builder: (context, formsSnapshot) {
                        if (!formsSnapshot.hasData) {
                          return const LinearProgressIndicator();
                        }
                        return formsSnapshot.data!.when(
                          success: (forms) {
                            if (forms.isEmpty) {
                              return const Text('No forms available');
                            }
                            _formUuid ??= _uuidFor(forms.first);
                            return DropdownButtonFormField<String>(
                              initialValue: _formUuid,
                              decoration: const InputDecoration(labelText: 'Form'),
                              items: forms
                                  .map((form) => DropdownMenuItem<String>(
                                        value: _uuidFor(form),
                                        child: Text(_labelFor(form, fallback: 'Form')),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null && _projectUuid != null) {
                                  _loadSections(_projectUuid!, value);
                                }
                              },
                            );
                          },
                          failure: (error) => Text(error.message),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _sectionsFuture ?? Future.value(ApiResult.success(<dynamic>[])),
                      builder: (context, sectionsSnapshot) {
                        if (!sectionsSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return sectionsSnapshot.data!.when(
                          success: (sections) => RefreshIndicator(
                            onRefresh: () async {
                              if (_projectUuid != null && _formUuid != null) {
                                await _loadSections(_projectUuid!, _formUuid!);
                              }
                            },
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: sections.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final section = sections[index];
                                final sectionUuid = _uuidFor(section);
                                return ListTile(
                                  leading: const Icon(Icons.view_week_outlined),
                                  title: Text(_labelFor(section, fallback: 'Section')),
                                  subtitle: Text(sectionUuid),
                                  onTap: sectionUuid.isEmpty
                                      ? null
                                      : () => Navigator.of(context).pushNamed(
                                            RouteNames.sectionDetail,
                                            arguments: {
                                              'projectUuid': _projectUuid ?? '',
                                              'formUuid': _formUuid ?? '',
                                              'sectionUuid': sectionUuid,
                                            },
                                          ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _updateSection(sectionUuid, _labelFor(section, fallback: 'Section'));
                                      } else if (value == 'delete') {
                                        _deleteSection(sectionUuid);
                                      } else if (value == 'versions' && _projectUuid != null && _formUuid != null) {
                                        Navigator.of(context).pushNamed(
                                          RouteNames.sectionVersions,
                                          arguments: {
                                            'projectUuid': _projectUuid!,
                                            'formUuid': _formUuid!,
                                            'sectionUuid': sectionUuid,
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
