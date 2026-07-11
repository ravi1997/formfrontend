import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/workflows/data/workflows_api.dart';

class WorkflowsRepositoryImpl {
  final WorkflowsApi _api;

  WorkflowsRepositoryImpl(this._api);

  Future<ApiResult<Map<String, dynamic>>> submitWorkflow({
    required String projectUuid,
    required String formUuid,
    Map<String, dynamic>? payload,
  }) {
    return _api.submitWorkflow(
      projectUuid: projectUuid,
      formUuid: formUuid,
      payload: payload,
    );
  }
}
