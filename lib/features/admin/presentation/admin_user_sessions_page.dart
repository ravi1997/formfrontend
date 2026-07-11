import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/state/session_state.dart';

class AdminUserSessionsPage extends StatefulWidget {
  const AdminUserSessionsPage({super.key});

  @override
  State<AdminUserSessionsPage> createState() => _AdminUserSessionsPageState();
}

class _AdminUserSessionsPageState extends State<AdminUserSessionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionStateNotifier>().fetchSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionStateNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: sessionState.isLoading ? null : sessionState.fetchSessions,
          ),
        ],
      ),
      body: sessionState.isLoading && sessionState.sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : sessionState.errorMessage != null && sessionState.sessions.isEmpty
              ? Center(child: Text(sessionState.errorMessage!))
              : ListView.separated(
                  itemCount: sessionState.sessions.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final session = sessionState.sessions[index];
                    final isCurrent = session.isCurrent;
                    return ListTile(
                      leading: Icon(isCurrent ? Icons.verified_user : Icons.devices),
                      title: Text(session.deviceName),
                      subtitle: Text(session.lastActiveAt),
                      trailing: isCurrent
                          ? const Text('Current')
                          : TextButton(
                              onPressed: sessionState.isLoading
                                  ? null
                                  : () => sessionState.revokeSession(session.uuid),
                              child: const Text('Revoke'),
                            ),
                    );
                  },
                ),
    );
  }
}
