import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/features/system/data/system_api.dart';

class SchemaEchoPage extends StatefulWidget {
  const SchemaEchoPage({super.key});

  @override
  State<SchemaEchoPage> createState() => _SchemaEchoPageState();
}

class _SchemaEchoPageState extends State<SchemaEchoPage> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<SystemApi>().schemaEcho();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schema Echo')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final result = snapshot.data!;
          return result.when(
            success: (data) => Center(child: Text(data.toString())),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
