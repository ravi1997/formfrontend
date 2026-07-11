import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';

class QuestionsListPage extends StatefulWidget {
  const QuestionsListPage({super.key});

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  late Future<ApiResult<List<dynamic>>> _projectsFuture;
  String? _projectUuid;
  String? _formUuid;
  String? _sectionUuid;
  Future<ApiResult<List<dynamic>>>? _formsFuture;
  Future<ApiResult<List<dynamic>>>? _sectionsFuture;
  Future<ApiResult<List<dynamic>>>? _questionsFuture;
  final _editQuestionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ProjectsApi>().listProjects();
  }

  @override
  void dispose() {
    _editQuestionController.dispose();
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
      _sectionUuid = null;
      _formsFuture = context.read<FormsApi>().listForms(projectUuid);
      _sectionsFuture = null;
      _questionsFuture = null;
    });
    await _formsFuture;
  }

  Future<void> _loadSections(String projectUuid, String formUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = null;
      _sectionsFuture = context.read<SectionsApi>().listSections(
        projectUuid: projectUuid,
        formUuid: formUuid,
      );
      _questionsFuture = null;
    });
    await _sectionsFuture;
  }

  Future<void> _loadQuestions(String projectUuid, String formUuid, String sectionUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = sectionUuid;
      _questionsFuture = context.read<QuestionsApi>().listQuestions(
        projectUuid: projectUuid,
        formUuid: formUuid,
        sectionUuid: sectionUuid,
      );
    });
    await _questionsFuture;
  }

  Future<void> _updateQuestion(String questionUuid, String currentName) async {
    final projectUuid = _projectUuid;
    final formUuid = _formUuid;
    final sectionUuid = _sectionUuid;
    if (projectUuid == null || formUuid == null || sectionUuid == null) return;
    final questionsApi = context.read<QuestionsApi>();
    _editQuestionController.text = currentName;
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit question'),
        content: TextField(
          controller: _editQuestionController,
          decoration: const InputDecoration(labelText: 'Question name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, _editQuestionController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final result = await questionsApi.updateQuestion(
      projectUuid: projectUuid,
      formUuid: formUuid,
      sectionUuid: sectionUuid,
      questionUuid: questionUuid,
      payload: {'name': name},
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Question updated' : result.errorOrNull?.message ?? 'Update failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _loadQuestions(projectUuid, formUuid, sectionUuid);
    }
  }

  Future<void> _deleteQuestion(String questionUuid) async {
    final projectUuid = _projectUuid;
    final formUuid = _formUuid;
    final sectionUuid = _sectionUuid;
    if (projectUuid == null || formUuid == null || sectionUuid == null) return;
    final questionsApi = context.read<QuestionsApi>();
    final result = await questionsApi.deleteQuestion(
      projectUuid: projectUuid,
      formUuid: formUuid,
      sectionUuid: sectionUuid,
      questionUuid: questionUuid,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.isSuccess ? 'Question deleted' : result.errorOrNull?.message ?? 'Delete failed'),
        ),
      );
    }
    if (result.isSuccess) {
      await _loadQuestions(projectUuid, formUuid, sectionUuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questions')),
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _sectionsFuture,
                      builder: (context, sectionsSnapshot) {
                        if (sectionsSnapshot.connectionState == ConnectionState.waiting && _sectionsFuture == null) {
                          return const SizedBox.shrink();
                        }
                        if (!sectionsSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        return sectionsSnapshot.data!.when(
                          success: (sections) {
                            if (sections.isEmpty) {
                              return const Text('No sections available');
                            }
                            _sectionUuid ??= _uuidFor(sections.first);
                            return DropdownButtonFormField<String>(
                              initialValue: _sectionUuid,
                              decoration: const InputDecoration(labelText: 'Section'),
                              items: sections
                                  .map((section) => DropdownMenuItem<String>(
                                        value: _uuidFor(section),
                                        child: Text(_labelFor(section, fallback: 'Section')),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null && _projectUuid != null && _formUuid != null) {
                                  _loadQuestions(_projectUuid!, _formUuid!, value);
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
                      future: _questionsFuture ?? Future.value(ApiResult.success(<dynamic>[])),
                      builder: (context, questionsSnapshot) {
                        if (!questionsSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return questionsSnapshot.data!.when(
                          success: (questions) => RefreshIndicator(
                            onRefresh: () async {
                              if (_projectUuid != null && _formUuid != null && _sectionUuid != null) {
                                await _loadQuestions(_projectUuid!, _formUuid!, _sectionUuid!);
                              }
                            },
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: questions.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final question = questions[index];
                                final questionUuid = _uuidFor(question);
                                return ListTile(
                                  leading: const Icon(Icons.help_outline),
                                  title: Text(_labelFor(question, fallback: 'Question')),
                                  subtitle: Text(questionUuid),
                                  onTap: questionUuid.isEmpty
                                      ? null
                                      : () => Navigator.of(context).pushNamed(
                                            RouteNames.questionDetail,
                                            arguments: {
                                              'projectUuid': _projectUuid ?? '',
                                              'formUuid': _formUuid ?? '',
                                              'sectionUuid': _sectionUuid ?? '',
                                              'questionUuid': questionUuid,
                                            },
                                          ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _updateQuestion(questionUuid, _labelFor(question, fallback: 'Question'));
                                      } else if (value == 'delete') {
                                        _deleteQuestion(questionUuid);
                                      } else if (value == 'versions' &&
                                          _projectUuid != null &&
                                          _formUuid != null &&
                                          _sectionUuid != null) {
                                        Navigator.of(context).pushNamed(
                                          RouteNames.questionVersions,
                                          arguments: {
                                            'projectUuid': _projectUuid!,
                                            'formUuid': _formUuid!,
                                            'sectionUuid': _sectionUuid!,
                                            'questionUuid': questionUuid,
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
