import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';

class SectionsRepositoryImpl {
  final SectionsApi _api;

  SectionsRepositoryImpl(this._api);

  Future<ApiResult<List<dynamic>>> listSections({
    required String projectUuid,
    required String formUuid,
  }) {
    return _api.listSections(projectUuid: projectUuid, formUuid: formUuid);
  }
}
