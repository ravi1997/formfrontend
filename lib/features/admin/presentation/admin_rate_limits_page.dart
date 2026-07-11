import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class AdminRateLimitsPage extends StatefulWidget {
  const AdminRateLimitsPage({super.key});

  @override
  State<AdminRateLimitsPage> createState() => _AdminRateLimitsPageState();
}

class _AdminRateLimitsPageState extends State<AdminRateLimitsPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AdminApi>().rateLimitStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Limits')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) => ListView(
              padding: const EdgeInsets.all(16),
              children: [Text(data.toString())],
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
