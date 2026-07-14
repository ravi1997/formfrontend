import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';

class ConditionApprovalPage extends StatefulWidget {
  const ConditionApprovalPage({super.key});

  @override
  State<ConditionApprovalPage> createState() => _ConditionApprovalPageState();
}

class _ConditionApprovalPageState extends State<ConditionApprovalPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ConditionsApi>().metadata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Condition Approval')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) {
              final status = data['status']?.toString() ?? 'Unknown';
              final approvedCount = data['approved_count']?.toString() ?? data['approved']?.toString() ?? 'Unknown';
              final pendingCount = data['pending_count']?.toString() ?? data['pending']?.toString() ?? 'Unknown';
              final canApprove = data['can_approve']?.toString() ?? 'Unknown';
              final transitionTarget = data['transition_target']?.toString() ?? data['target']?.toString() ?? 'Unknown';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Approval Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Status: $status'),
                          Text('Approved: $approvedCount'),
                          Text('Pending: $pendingCount'),
                          Text('Can approve: $canApprove'),
                          Text('Transition target: $transitionTarget'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Approval actions', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          const Text('Use the backend approval transition or rollback endpoints from this surface.'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: const [
                              ElevatedButton(onPressed: null, child: Text('Transition')),
                              OutlinedButton(onPressed: null, child: Text('Rollback')),
                            ],
                          ),
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
