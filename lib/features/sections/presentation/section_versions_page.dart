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
            success: (versions) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Section Versions', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Version count: ${versions.length}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...versions.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Version ${entry.key + 1}', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Type: ${entry.value.runtimeType}'),
                            const SizedBox(height: 8),
                            SelectableText(entry.value.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
