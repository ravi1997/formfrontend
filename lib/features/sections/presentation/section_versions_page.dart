import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';

class SectionVersionsPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;

  const SectionVersionsPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
  });

  @override
  State<SectionVersionsPage> createState() => _SectionVersionsPageState();
}

class _SectionVersionsPageState extends State<SectionVersionsPage> {
  late Future<ApiResult<List<dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<SectionsApi>().listSectionVersions(
          projectUuid: widget.projectUuid,
          formUuid: widget.formUuid,
          sectionUuid: widget.sectionUuid,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Section Versions')),
      body: FutureBuilder<ApiResult<List<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
