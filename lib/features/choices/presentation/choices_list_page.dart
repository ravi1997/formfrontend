import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';
import 'package:formfrontend/features/choices/presentation/choice_edit_page.dart';

class ChoicesListPage extends StatefulWidget {
  const ChoicesListPage({super.key});

  @override
  State<ChoicesListPage> createState() => _ChoicesListPageState();
}

class _ChoicesListPageState extends State<ChoicesListPage> {
  late Future<ApiResult<List<dynamic>>> _projectsFuture;
  String? _projectUuid;
  String? _formUuid;
  String? _sectionUuid;
  String? _questionUuid;
  Future<ApiResult<List<dynamic>>>? _formsFuture;
  Future<ApiResult<List<dynamic>>>? _sectionsFuture;
  Future<ApiResult<List<dynamic>>>? _questionsFuture;
  Future<ApiResult<List<dynamic>>>? _choicesFuture;
  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ProjectsApi>().listProjects();
  }

  String _uuidFor(dynamic item) => item is Map<String, dynamic>
      ? (item['uuid'] ?? item['id'] ?? '').toString()
      : item.toString();

  String _labelFor(dynamic item, {String fallback = 'Unnamed'}) =>
      item is Map<String, dynamic>
      ? (item['name'] ??
                item['title'] ??
                item['slug'] ??
                item['uuid'] ??
                item['id'] ??
                fallback)
            .toString()
      : item.toString();

  Future<void> _loadForms(String projectUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = null;
      _sectionUuid = null;
      _questionUuid = null;
      _formsFuture = context.read<FormsApi>().listForms(projectUuid);
      _sectionsFuture = null;
      _questionsFuture = null;
      _choicesFuture = null;
    });
    await _formsFuture;
  }

  Future<void> _loadSections(String projectUuid, String formUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = null;
      _questionUuid = null;
      _sectionsFuture = context.read<SectionsApi>().listSections(
        projectUuid: projectUuid,
        formUuid: formUuid,
      );
      _questionsFuture = null;
      _choicesFuture = null;
    });
    await _sectionsFuture;
  }

  Future<void> _loadQuestions(
    String projectUuid,
    String formUuid,
    String sectionUuid,
  ) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = sectionUuid;
      _questionUuid = null;
      _questionsFuture = context.read<QuestionsApi>().listQuestions(
        projectUuid: projectUuid,
        formUuid: formUuid,
        sectionUuid: sectionUuid,
      );
      _choicesFuture = null;
    });
    await _questionsFuture;
  }

  Future<void> _loadChoices(
    String projectUuid,
    String formUuid,
    String sectionUuid,
    String questionUuid,
  ) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = sectionUuid;
      _questionUuid = questionUuid;
      _choicesFuture = context.read<ChoicesApi>().listChoices(
        projectUuid: projectUuid,
        formUuid: formUuid,
        sectionUuid: sectionUuid,
        questionUuid: questionUuid,
      );
    });
    await _choicesFuture;
  }

  Future<void> _createChoice() async {
    final projectUuid = _projectUuid;
    final formUuid = _formUuid;
    final sectionUuid = _sectionUuid;
    final questionUuid = _questionUuid;
    if (projectUuid == null ||
        formUuid == null ||
        sectionUuid == null ||
        questionUuid == null) {
      return;
    }
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChoiceEditPage(
          projectUuid: projectUuid,
          formUuid: formUuid,
          sectionUuid: sectionUuid,
          questionUuid: questionUuid,
        ),
      ),
    );
    if (created == true) {
      await _loadChoices(projectUuid, formUuid, sectionUuid, questionUuid);
    }
  }

  Future<void> _updateChoice(String choiceUuid) async {
    final projectUuid = _projectUuid;
    final formUuid = _formUuid;
    final sectionUuid = _sectionUuid;
    final questionUuid = _questionUuid;
    if (projectUuid == null ||
        formUuid == null ||
        sectionUuid == null ||
        questionUuid == null) {
      return;
    }
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ChoiceEditPage(
          projectUuid: projectUuid,
          formUuid: formUuid,
          sectionUuid: sectionUuid,
          questionUuid: questionUuid,
          choiceUuid: choiceUuid,
        ),
      ),
    );
    if (changed == true) {
      await _loadChoices(projectUuid, formUuid, sectionUuid, questionUuid);
    }
  }

  Future<void> _deleteChoice(String choiceUuid) async {
    final projectUuid = _projectUuid;
    final formUuid = _formUuid;
    final sectionUuid = _sectionUuid;
    final questionUuid = _questionUuid;
    if (projectUuid == null ||
        formUuid == null ||
        sectionUuid == null ||
        questionUuid == null) {
      return;
    }
    final choicesApi = context.read<ChoicesApi>();
    final result = await choicesApi.deleteChoice(
      projectUuid: projectUuid,
      formUuid: formUuid,
      sectionUuid: sectionUuid,
      questionUuid: questionUuid,
      choiceUuid: choiceUuid,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isSuccess
                ? 'Choice deleted'
                : result.errorOrNull?.message ?? 'Delete failed',
          ),
        ),
      );
    }
    if (result.isSuccess) {
      await _loadChoices(projectUuid, formUuid, sectionUuid, questionUuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _questionUuid == null ? null : () => _createChoice(),
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
              _projectUuid ??= _uuidFor(projects.first);
              _formsFuture ??= context.read<FormsApi>().listForms(
                _projectUuid!,
              );
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      initialValue: _projectUuid,
                      decoration: const InputDecoration(labelText: 'Project'),
                      items: projects
                          .map(
                            (e) => DropdownMenuItem(
                              value: _uuidFor(e),
                              child: Text(_labelFor(e)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) _loadForms(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _formsFuture,
                      builder: (context, formsSnapshot) {
                        if (!formsSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        return formsSnapshot.data!.when(
                          success: (forms) {
                            if (forms.isEmpty) {
                              return const Text('No forms available');
                            }
                            _formUuid ??= _uuidFor(forms.first);
                            return DropdownButtonFormField<String>(
                              initialValue: _formUuid,
                              decoration: const InputDecoration(
                                labelText: 'Form',
                              ),
                              items: forms
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: _uuidFor(e),
                                      child: Text(_labelFor(e)),
                                    ),
                                  )
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _sectionsFuture,
                      builder: (context, sectionsSnapshot) {
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
                              decoration: const InputDecoration(
                                labelText: 'Section',
                              ),
                              items: sections
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: _uuidFor(e),
                                      child: Text(_labelFor(e)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null &&
                                    _projectUuid != null &&
                                    _formUuid != null) {
                                  _loadQuestions(
                                    _projectUuid!,
                                    _formUuid!,
                                    value,
                                  );
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _questionsFuture,
                      builder: (context, questionsSnapshot) {
                        if (!questionsSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        return questionsSnapshot.data!.when(
                          success: (questions) {
                            if (questions.isEmpty) {
                              return const Text('No questions available');
                            }
                            _questionUuid ??= _uuidFor(questions.first);
                            return DropdownButtonFormField<String>(
                              initialValue: _questionUuid,
                              decoration: const InputDecoration(
                                labelText: 'Question',
                              ),
                              items: questions
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: _uuidFor(e),
                                      child: Text(_labelFor(e)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null &&
                                    _projectUuid != null &&
                                    _formUuid != null &&
                                    _sectionUuid != null) {
                                  _loadChoices(
                                    _projectUuid!,
                                    _formUuid!,
                                    _sectionUuid!,
                                    value,
                                  );
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
                      future:
                          _choicesFuture ??
                          Future.value(ApiResult.success(<dynamic>[])),
                      builder: (context, choicesSnapshot) {
                        if (!choicesSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return choicesSnapshot.data!.when(
                          success: (choices) => ListView.separated(
                            itemCount: choices.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final choice = choices[index];
                              final choiceUuid = _uuidFor(choice);
                              return ListTile(
                                leading: const Icon(Icons.circle_outlined),
                                title: Text(
                                  _labelFor(choice, fallback: 'Choice'),
                                ),
                                subtitle: Text(choiceUuid),
                                onTap: choiceUuid.isEmpty
                                    ? null
                                    : () => _updateChoice(choiceUuid),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _updateChoice(choiceUuid);
                                    } else if (value == 'delete') {
                                      _deleteChoice(choiceUuid);
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          failure: (error) =>
                              Center(child: Text(error.message)),
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
