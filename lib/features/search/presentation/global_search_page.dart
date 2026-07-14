import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/search/data/search_api.dart';

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final _controller = TextEditingController();
  Future<ApiResult<List<dynamic>>>? _future;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _future = context.read<SearchApi>().search(query: query);
    });
  }

  Widget _buildResultTile(Map<String, dynamic> item) {
    final kind = item['kind']?.toString() ?? 'item';
    final title = item['title']?.toString() ?? 'Untitled';
    final subtitle = item['subtitle']?.toString() ?? '';
    final initial = kind.isNotEmpty ? kind[0].toUpperCase() : 'I';
    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(title),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: Text(kind),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Search everything',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _submit,
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          if (_future == null)
            const Text(
              'Search projects, forms, responses, organizations, and users.',
            )
          else
            FutureBuilder<ApiResult<List<dynamic>>>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return snapshot.data!.when(
                  success: (items) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Results: ${items.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...items.map((item) {
                        final map = item is Map<String, dynamic>
                            ? item
                            : item is Map
                            ? Map<String, dynamic>.from(item)
                            : <String, dynamic>{};
                        return Card(child: _buildResultTile(map));
                      }),
                    ],
                  ),
                  failure: (error) => Text(error.message),
                );
              },
            ),
        ],
      ),
    );
  }
}
