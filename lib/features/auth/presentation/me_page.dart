import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/auth/data/auth_api.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AuthApi>().getMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (data) {
              final name = data['name']?.toString() ?? 'Unknown';
              final email = data['email']?.toString() ?? 'Unknown';
              final uuid = data['uuid']?.toString() ?? 'Unknown';
              final status = data['status']?.toString() ?? 'Unknown';
              final roles = data['roles'] is List ? (data['roles'] as List).map((e) => e.toString()).toList() : const <String>[];
              final isSuperAdmin = data['is_super_admin']?.toString() ?? data['super_admin']?.toString() ?? 'Unknown';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profile Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('UUID: $uuid'),
                          Text('Name: $name'),
                          Text('Email: $email'),
                          Text('Status: $status'),
                          Text('Roles: ${roles.length}'),
                          Text('Super admin: $isSuperAdmin'),
                          if (roles.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text('Role list: ${roles.join(', ')}'),
                          ],
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
                          Text('Profile payload', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          SelectableText(data.toString()),
                        ],
                      ),
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
