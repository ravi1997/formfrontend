import 'package:flutter/material.dart';

class TemplateDetailPage extends StatelessWidget {
  final String templateUuid;
  const TemplateDetailPage({super.key, required this.templateUuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Template Detail')),
      body: Center(child: Text(templateUuid)),
    );
  }
}
