import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formfrontend/features/forms/presentation/widgets/effective_ui_field_utils.dart';

class EffectiveUiForm extends StatefulWidget {
  final Map<String, dynamic> ui;
  final Widget? footer;
  final bool includePreviewButton;
  final String previewButtonLabel;
  final void Function(Map<String, dynamic> payload)? onPayloadPreview;

  const EffectiveUiForm({
    super.key,
    required this.ui,
    this.footer,
    this.includePreviewButton = false,
    this.previewButtonLabel = 'Preview Payload',
    this.onPayloadPreview,
  });

  @override
  State<EffectiveUiForm> createState() => _EffectiveUiFormState();
}

class _EffectiveUiFormState extends State<EffectiveUiForm> {
  final Map<String, Map<String, dynamic>> _fieldDefinitions = {};
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String key, [String? initialValue]) {
    return _controllers.putIfAbsent(
      key,
      () => TextEditingController(text: initialValue ?? ''),
    );
  }

  Map<String, dynamic> extractPayload() {
    return EffectiveUiFieldUtils.coerceValue(
      _fieldDefinitions,
      _controllers.map((key, controller) => MapEntry(key, controller.text)),
    );
  }

  List<String> validateRequired() {
    return EffectiveUiFieldUtils.validateRequired(
      _fieldDefinitions,
      _controllers.map((key, controller) => MapEntry(key, controller.text)),
    );
  }

  Widget _buildField(dynamic field, [int index = 0]) {
    if (field is! Map<String, dynamic>) {
      return ListTile(
        title: Text('Field ${index + 1}'),
        subtitle: Text(field.toString()),
      );
    }

    final key = (field['key'] ?? field['name'] ?? field['id'] ?? 'field_$index').toString();
    final label = (field['label'] ?? field['title'] ?? key).toString();
    final type = (field['type'] ?? 'text').toString();
    final required = field['required'] == true;
    final placeholder = field['placeholder']?.toString();
    final controller = _controllerFor(key, field['default']?.toString());
    _fieldDefinitions[key] = field;

    final decoration = InputDecoration(
      labelText: required ? '$label *' : label,
      hintText: placeholder,
    );

    switch (type) {
      case 'multiline':
      case 'textarea':
        return TextField(
          controller: controller,
          maxLines: 5,
          decoration: decoration,
        );
      default:
        return TextField(
          controller: controller,
          decoration: decoration,
        );
    }
  }

  List<Widget> _buildUiWidgets() {
    final widgets = <Widget>[];
    final fields = widget.ui['fields'];

    if (fields is List) {
      for (var i = 0; i < fields.length; i++) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildField(fields[i], i),
        ));
      }
    } else {
      widgets.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Effective UI payload', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SelectableText(widget.ui.toString()),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final payload = extractPayload();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._buildUiWidgets(),
        if (widget.footer != null) ...[
          const SizedBox(height: 12),
          widget.footer!,
        ],
        if (widget.includePreviewButton) ...[
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final currentPayload = extractPayload();
              widget.onPayloadPreview?.call(currentPayload);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(jsonEncode(currentPayload))),
              );
            },
            child: Text(widget.previewButtonLabel),
          ),
        ],
        if (payload.isNotEmpty) const SizedBox(height: 0),
      ],
    );
  }
}
