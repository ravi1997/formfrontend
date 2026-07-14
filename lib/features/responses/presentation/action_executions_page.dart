import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/responses/data/responses_api.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';

class ActionExecutionsPage extends StatefulWidget {
  const ActionExecutionsPage({super.key});

  @override
  State<ActionExecutionsPage> createState() => _ActionExecutionsPageState();
}

class _ActionExecutionsPageState extends State<ActionExecutionsPage> {
  late Future<ApiResult<List<dynamic>>> _projectsFuture;
  String? _projectUuid;
  String? _formUuid;
  String? _sectionUuid;
  String? _questionUuid;
  String? _responseUuid;
  Future<ApiResult<List<dynamic>>>? _formsFuture;
  Future<ApiResult<List<dynamic>>>? _sectionsFuture;
  Future<ApiResult<List<dynamic>>>? _questionsFuture;
  Future<ApiResult<List<dynamic>>>? _choicesFuture;
  Future<ApiResult<Map<String, dynamic>>>? _executionsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ProjectsApi>().listProjects();
  }

  String _uuidFor(dynamic item) =>
      item is Map<String, dynamic> ? (item['uuid'] ?? item['id'] ?? '').toString() : item.toString();

  String _labelFor(dynamic item, {String fallback = 'Unnamed'}) => item is Map<String, dynamic>
      ? (item['name'] ?? item['title'] ?? item['slug'] ?? item['uuid'] ?? item['id'] ?? fallback).toString()
      : item.toString();

  Future<void> _loadForms(String projectUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = null;
      _sectionUuid = null;
      _questionUuid = null;
      _responseUuid = null;
      _formsFuture = context.read<FormsApi>().listForms(projectUuid);
      _sectionsFuture = null;
      _questionsFuture = null;
      _choicesFuture = null;
      _executionsFuture = null;
    });
    await _formsFuture;
  }

  Future<void> _loadSections(String projectUuid, String formUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = null;
      _questionUuid = null;
      _responseUuid = null;
      _sectionsFuture = context.read<SectionsApi>().listSections(projectUuid: projectUuid, formUuid: formUuid);
      _questionsFuture = null;
      _choicesFuture = null;
      _executionsFuture = null;
    });
    await _sectionsFuture;
  }

  Future<void> _loadQuestions(String projectUuid, String formUuid, String sectionUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = sectionUuid;
      _questionUuid = null;
      _responseUuid = null;
      _questionsFuture = context.read<QuestionsApi>().listQuestions(
            projectUuid: projectUuid,
            formUuid: formUuid,
            sectionUuid: sectionUuid,
          );
      _choicesFuture = null;
      _executionsFuture = null;
    });
    await _questionsFuture;
  }

  Future<void> _loadChoices(String projectUuid, String formUuid, String sectionUuid, String questionUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _sectionUuid = sectionUuid;
      _questionUuid = questionUuid;
      _responseUuid = null;
      _choicesFuture = context.read<ChoicesApi>().listChoices(
            projectUuid: projectUuid,
            formUuid: formUuid,
            sectionUuid: sectionUuid,
            questionUuid: questionUuid,
          );
      _executionsFuture = null;
    });
    await _choicesFuture;
  }

  Future<void> _loadExecutions(String projectUuid, String formUuid, String responseUuid) async {
    setState(() {
      _projectUuid = projectUuid;
      _formUuid = formUuid;
      _responseUuid = responseUuid;
      _executionsFuture = context.read<ResponsesApi>().listActionExecutions(
            projectUuid: projectUuid,
            formUuid: formUuid,
            responseUuid: responseUuid,
          );
    });
    await _executionsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Action Executions')),
      body: FutureBuilder<ApiResult<List<dynamic>>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return snapshot.data!.when(
            success: (projects) {
              if (projects.isEmpty) return const Center(child: Text('No projects available'));
              _projectUuid ??= _uuidFor(projects.first);
              _formsFuture ??= context.read<FormsApi>().listForms(_projectUuid!);
              return Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Action Executions'),
                          SizedBox(height: 8),
                          Text('Choose a project, form, section, question, and response to inspect backend execution history.'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      initialValue: _projectUuid,
                      decoration: const InputDecoration(labelText: 'Project'),
                      items: projects
                          .map((e) => DropdownMenuItem(value: _uuidFor(e), child: Text(_labelFor(e))))
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
                        if (!formsSnapshot.hasData) return const SizedBox.shrink();
                        return formsSnapshot.data!.when(
                          success: (forms) {
                            if (forms.isEmpty) return const Text('No forms available');
                            _formUuid ??= _uuidFor(forms.first);
                            return DropdownButtonFormField<String>(
                              initialValue: _formUuid,
                              decoration: const InputDecoration(labelText: 'Form'),
                              items: forms
                                  .map((e) => DropdownMenuItem(value: _uuidFor(e), child: Text(_labelFor(e))))
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
                        if (!sectionsSnapshot.hasData) return const SizedBox.shrink();
                        return sectionsSnapshot.data!.when(
                          success: (sections) {
                            if (sections.isEmpty) return const Text('No sections available');
                            _sectionUuid ??= _uuidFor(sections.first);
                            return DropdownButtonFormField<String>(
                              initialValue: _sectionUuid,
                              decoration: const InputDecoration(labelText: 'Section'),
                              items: sections
                                  .map((e) => DropdownMenuItem(value: _uuidFor(e), child: Text(_labelFor(e))))
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FutureBuilder<ApiResult<List<dynamic>>>(
                      future: _questionsFuture,
                      builder: (context, questionsSnapshot) {
                        if (!questionsSnapshot.hasData) return const SizedBox.shrink();
                        return questionsSnapshot.data!.when(
                          success: (questions) {
                            if (questions.isEmpty) return const Text('No questions available');
                            _questionUuid ??= _uuidFor(questions.first);
                            return DropdownButtonFormField<String>(
                              initialValue: _questionUuid,
                              decoration: const InputDecoration(labelText: 'Question'),
                              items: questions
                                  .map((e) => DropdownMenuItem(value: _uuidFor(e), child: Text(_labelFor(e))))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null && _projectUuid != null && _formUuid != null && _sectionUuid != null) {
                                  _loadChoices(_projectUuid!, _formUuid!, _sectionUuid!, value);
                                }
                              },
                            );
                          },
                          failure: (error) => Text(error.message),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Response UUID',
                        hintText: 'Enter a response UUID to inspect action executions',
                      ),
                      onChanged: (value) {
                        _responseUuid = value.trim().isEmpty ? null : value.trim();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _projectUuid != null &&
                            _formUuid != null &&
                            _responseUuid != null &&
                            _responseUuid!.isNotEmpty
                        ? () => _loadExecutions(_projectUuid!, _formUuid!, _responseUuid!)
                        : null,
                    child: const Text('Load Executions'),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FutureBuilder<ApiResult<Map<String, dynamic>>>(
                      future: _executionsFuture,
                      builder: (context, executionsSnapshot) {
                        if (!executionsSnapshot.hasData) return const Center(child: Text('Select a response and load executions'));
                        return executionsSnapshot.data!.when(
                          success: (data) => SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Execution payload', style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 8),
                                    Text('Fields: ${data.keys.length}'),
                                    const SizedBox(height: 8),
                                    SelectableText(data.toString()),
                                  ],
                                ),
                              ),
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
