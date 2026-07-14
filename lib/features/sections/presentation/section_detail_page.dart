import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';

class SectionDetailPage extends StatefulWidget {
  final String projectUuid;
  final String formUuid;
  final String sectionUuid;

  const SectionDetailPage({
    super.key,
    required this.projectUuid,
    required this.formUuid,
    required this.sectionUuid,
  });

  @override
  State<SectionDetailPage> createState() => _SectionDetailPageState();
}

class _SectionDetailPageState extends State<SectionDetailPage> {
  late Future<ApiResult<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<SectionsApi>().getSection(
          projectUuid: widget.projectUuid,
          formUuid: widget.formUuid,
          sectionUuid: widget.sectionUuid,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Section Detail')),
      body: FutureBuilder<ApiResult<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return snapshot.data!.when(
            success: (data) {
              final name = data['name']?.toString() ?? 'Unnamed section';
              final status = data['status']?.toString() ?? 'Unknown';
              final questionCount = data['questions'] is List ? (data['questions'] as List).length : null;
              final position = data['position']?.toString() ?? data['order']?.toString() ?? 'Unknown';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Status: $status'),
                            Text('Position: $position'),
                            Text('Questions: ${questionCount ?? 'Unknown'}'),
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
                ),
              );
            },
            failure: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}
