import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/workflows/data/workflows_api.dart';

class WorkflowActionsPage extends StatefulWidget {
  const WorkflowActionsPage({super.key});

  @override
  State<WorkflowActionsPage> createState() => _WorkflowActionsPageState();
}

class _WorkflowActionsPageState extends State<WorkflowActionsPage> {
  late Future<List<dynamic>> _projectsFuture;
  String? _projectUuid;
  String? _formUuid;
  Future<dynamic>? _formsFuture;
  String _action = 'submit';

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ProjectsApi>().listProjects().then(
          (result) => result.when(success: (data) => data, failure: (_) => <dynamic>[]),
        );
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
    });
    await _formsFuture;
  }

  Future<void> _runAction() async {
    if (_projectUuid == null || _formUuid == null) return;
    final api = context.read<WorkflowsApi>();
    switch (_action) {
      case 'review':
        await api.reviewWorkflow(projectUuid: _projectUuid!, formUuid: _formUuid!);
        break;
      case 'approve':
        await api.approveWorkflow(projectUuid: _projectUuid!, formUuid: _formUuid!);
        break;
      default:
        await api.submitWorkflow(projectUuid: _projectUuid!, formUuid: _formUuid!);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workflow $_action request sent')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workflow Actions')),
      body: FutureBuilder<List<dynamic>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final projects = snapshot.data!;
          if (projects.isEmpty) return const Center(child: Text('No projects available'));
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
                      .map((e) => DropdownMenuItem(value: _uuidFor(e), child: Text(_labelFor(e))))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _loadForms(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<dynamic>(
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
                              .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem<String>(
                                  value: _uuidFor(e),
                                  child: Text(_labelFor(e)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _formUuid = value);
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
                child: DropdownButtonFormField<String>(
                  initialValue: _action,
                  decoration: const InputDecoration(labelText: 'Action'),
                  items: const [
                    DropdownMenuItem(value: 'submit', child: Text('Submit')),
                    DropdownMenuItem(value: 'review', child: Text('Review')),
                    DropdownMenuItem(value: 'approve', child: Text('Approve')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _action = value);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _projectUuid != null && _formUuid != null ? _runAction : null,
                child: const Text('Send Workflow Action'),
              ),
            ],
          );
        },
      ),
    );
  }
}
