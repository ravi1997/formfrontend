class ErrorPayload {
  final String message;
  final String? code;
  final List<ValidationErrorDetail>? details;

  const ErrorPayload({
    required this.message,
    this.code,
    this.details,
  });

  factory ErrorPayload.fromJson(Map<String, dynamic> json) {
    var detailsList = json['details'] as List?;
    List<ValidationErrorDetail>? parsedDetails;
    if (detailsList != null) {
      parsedDetails = detailsList
          .map((e) => ValidationErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ErrorPayload(
      message: json['message'] as String? ?? 'An unexpected error occurred',
      code: json['code'] as String?,
      details: parsedDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (code != null) 'code': code,
      if (details != null) 'details': details!.map((e) => e.toJson()).toList(),
    };
  }
}

class ValidationErrorDetail {
  final String field;
  final String message;

  const ValidationErrorDetail({
    required this.field,
    required this.message,
  });

  factory ValidationErrorDetail.fromJson(Map<String, dynamic> json) {
    return ValidationErrorDetail(
      field: json['field'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'message': message,
    };
  }
}
