import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';

class FormVersionsPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;

  const FormVersionsPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
  });

  @override
  State<FormVersionsPage> createState() => _FormVersionsPageState();
}

class _FormVersionsPageState extends State<FormVersionsPage> {
  late Future<ApiResult<List<dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<FormsApi>().listFormVersions(widget.projectUuid, widget.formUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Versions')),
      body: FutureBuilder<ApiResult<List<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.when(
            success: (versions) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: versions.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) => ListTile(
                title: Text(versions[index].toString()),
              ),
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
