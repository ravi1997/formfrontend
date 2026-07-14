import 'package:flutter_test/flutter_test.dart';
import 'package:formfrontend/core/api/api_response_parsers.dart';

void main() {
  test('parseList accepts common list envelopes', () {
    expect(ApiResponseParsers.parseList({'items': [1, 2]}), [1, 2]);
    expect(ApiResponseParsers.parseList({'data': ['a']}), ['a']);
    expect(ApiResponseParsers.parseList({'results': [true]}), [true]);
    expect(ApiResponseParsers.parseList([3, 4]), [3, 4]);
    expect(ApiResponseParsers.parseList({'unexpected': 'shape'}), isEmpty);
  });
}
