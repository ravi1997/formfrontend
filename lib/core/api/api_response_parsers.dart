class ApiResponseParsers {
  static List<dynamic> parseList(dynamic data) {
    if (data is List<dynamic>) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      final items = data['items'];
      if (items is List<dynamic>) {
        return items;
      }
      final dataField = data['data'];
      if (dataField is List<dynamic>) {
        return dataField;
      }
      final results = data['results'];
      if (results is List<dynamic>) {
        return results;
      }
    }
    return const <dynamic>[];
  }
}
