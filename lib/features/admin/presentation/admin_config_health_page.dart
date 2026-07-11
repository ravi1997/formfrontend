import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';

class AdminConfigHealthPage extends StatefulWidget {
  const AdminConfigHealthPage({super.key});

  @override
  State<AdminConfigHealthPage> createState() => _AdminConfigHealthPageState();
}

class _AdminConfigHealthPageState extends State<AdminConfigHealthPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AdminApi>().configHealth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Config Health')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(data.toString()),
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
