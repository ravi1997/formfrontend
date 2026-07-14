class EffectiveUiFieldUtils {
  static Map<String, dynamic> coerceValue(
    Map<String, Map<String, dynamic>> fieldDefinitions,
    Map<String, String> rawValues,
  ) {
    final payload = <String, dynamic>{};
    for (final entry in rawValues.entries) {
      final definition = fieldDefinitions[entry.key] ?? const <String, dynamic>{};
      final type = (definition['type'] ?? 'text').toString();
      final raw = entry.value.trim();
      if (raw.isEmpty) {
        payload[entry.key] = '';
        continue;
      }

      switch (type) {
        case 'int':
        case 'integer':
          payload[entry.key] = int.tryParse(raw) ?? raw;
          break;
        case 'number':
        case 'float':
        case 'double':
          payload[entry.key] = double.tryParse(raw) ?? raw;
          break;
        case 'bool':
        case 'boolean':
          payload[entry.key] = raw.toLowerCase() == 'true';
          break;
        default:
          payload[entry.key] = raw;
      }
    }
    return payload;
  }

  static List<String> validateRequired(
    Map<String, Map<String, dynamic>> fieldDefinitions,
    Map<String, String> rawValues,
  ) {
    final errors = <String>[];
    for (final entry in fieldDefinitions.entries) {
      final definition = entry.value;
      final required = definition['required'] == true;
      if (!required) continue;
      final raw = rawValues[entry.key]?.trim() ?? '';
      if (raw.isEmpty) {
        final label = (definition['label'] ?? definition['title'] ?? entry.key).toString();
        errors.add('$label is required');
      }
    }
    return errors;
  }
}
