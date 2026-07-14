import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/forms/presentation/widgets/effective_ui_form.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/responses/data/responses_api.dart';

class ResponseSubmissionPage extends StatefulWidget {
  const ResponseSubmissionPage({super.key});

  @override
  State<ResponseSubmissionPage> createState() => _ResponseSubmissionPageState();
}

class _ResponseSubmissionPageState extends State<ResponseSubmissionPage> {
  late Future<List<dynamic>> _projectsFuture;
  String? _projectUuid;
  String? _formUuid;
  Future<ApiResult<List<dynamic>>>? _formsFuture;
  Future<ApiResult<Map<String, dynamic>>>? _effectiveUiFuture;
  Map<String, dynamic> _effectiveUi = <String, dynamic>{};
  final _responseController = TextEditingController(text: '{"sample":"value"}');
  ApiResult<Map<String, dynamic>>? _submitResult;

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ProjectsApi>().listProjects().then(
          (result) => result.when(success: (data) => data, failure: (_) => <dynamic>[]),
        );
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
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
      _formsFuture = context.read<FormsApi>().listForms(projectUuid);
      _effectiveUiFuture = null;
      _effectiveUi = <String, dynamic>{};
    });
    await _formsFuture;
  }

  Future<void> _loadEffectiveUi(String projectUuid, String formUuid) async {
    final future = context.read<FormsApi>().getEffectiveUi(projectUuid, formUuid);
    setState(() {
      _effectiveUiFuture = future;
    });
    final result = await future;
    if (!mounted) return;
    result.when(
      success: (ui) => setState(() {
        _effectiveUi = ui;
      }),
      failure: (_) => setState(() {
        _effectiveUi = <String, dynamic>{};
      }),
    );
  }

  Future<void> _submitResponse() async {
    if (_projectUuid == null || _formUuid == null) return;
    final raw = _responseController.text.trim();
    Map<String, dynamic> parsed;
    if (_effectiveUi.isEmpty) {
      if (raw.isEmpty) {
        parsed = <String, dynamic>{};
      } else {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is Map<String, dynamic>) {
            parsed = decoded;
          } else {
            parsed = <String, dynamic>{'response': decoded};
          }
        } catch (_) {
          parsed = <String, dynamic>{'response': raw};
        }
      }
    } else {
      parsed = <String, dynamic>{'effective_ui': _effectiveUi};
    }
    final result = await context.read<ResponsesApi>().submitResponse(
      projectUuid: _projectUuid!,
      formUuid: _formUuid!,
      payload: parsed,
    );
    if (mounted) {
      setState(() {
        _submitResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Response Submission')),
      body: FutureBuilder<List<dynamic>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final projects = snapshot.data!;
          if (projects.isEmpty) return const Center(child: Text('No projects available'));
          _projectUuid ??= _uuidFor(projects.first);
          _formsFuture ??= context.read<FormsApi>().listForms(_projectUuid!);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_submitResult != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _submitResult!.when(
                      success: (data) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Submission Result', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Status: success'),
                          const SizedBox(height: 8),
                          SelectableText(data.toString()),
                        ],
                      ),
                      failure: (error) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Submission Result', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Status: failure'),
                          const SizedBox(height: 8),
                          Text(error.message),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                initialValue: _projectUuid,
                decoration: const InputDecoration(labelText: 'Project'),
                items: projects
                    .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem<String>(
                        value: _uuidFor(e),
                        child: Text(_labelFor(e)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) _loadForms(value);
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder<ApiResult<List<dynamic>>>(
                future: _formsFuture,
                builder: (context, formsSnapshot) {
                  if (!formsSnapshot.hasData) return const SizedBox.shrink();
                  return formsSnapshot.data!.when(
                    success: (forms) {
                      final formItems = forms;
                      if (formItems.isEmpty) return const Text('No forms available');
                      _formUuid ??= _uuidFor(formItems.first);
                      return DropdownButtonFormField<String>(
                        initialValue: _formUuid,
                        decoration: const InputDecoration(labelText: 'Form'),
                        items: formItems
                            .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                value: _uuidFor(e),
                                child: Text(_labelFor(e)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null && _projectUuid != null) {
                            setState(() {
                              _formUuid = value;
                              _effectiveUi = <String, dynamic>{};
                            });
                            _loadEffectiveUi(_projectUuid!, value);
                          }
                        },
                      );
                    },
                    failure: (error) => Text(error.message),
                  );
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder<ApiResult<Map<String, dynamic>>>(
                future: _projectUuid != null && _formUuid != null
                    ? (_effectiveUiFuture ??
                        context.read<FormsApi>().getEffectiveUi(
                              _projectUuid!,
                              _formUuid!,
                            ))
                    : null,
                builder: (context, uiSnapshot) {
                  if (_projectUuid == null || _formUuid == null) {
                    return const SizedBox.shrink();
                  }
                  if (!uiSnapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return uiSnapshot.data!.when(
                    success: (ui) => EffectiveUiForm(
                      ui: ui,
                      footer: TextField(
                        controller: _responseController,
                        decoration: const InputDecoration(
                          labelText: 'Fallback JSON',
                          helperText: 'Used only if the effective UI fields are empty.',
                        ),
                        maxLines: 6,
                      ),
                    ),
                    failure: (error) => Column(
                      children: [
                        Text(error.message),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _responseController,
                          decoration: const InputDecoration(
                            labelText: 'Payload JSON',
                            helperText: 'Paste a JSON object. Non-JSON input is wrapped as "response".',
                          ),
                          maxLines: 6,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _projectUuid != null && _formUuid != null ? _submitResponse : null,
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }
}
