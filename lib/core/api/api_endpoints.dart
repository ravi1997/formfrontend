class ApiEndpoints {
  // Operational
  static const String health = '/health';
  static const String liveness = '/liveness';
  static const String readiness = '/readiness';
  static const String ready = '/ready';
  static const String metrics = '/metrics';
  static const String echoForm = '/schemas/echo-form';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String sessions = '/auth/sessions';
  static const String revokeSession = '/auth/sessions/revoke';
  static const String logoutAll = '/auth/logout-all';

  // Admin Security
  static String userSessions(String userUuid) => '/auth/admin/users/$userUuid/sessions';
  static String revokeUserSession(String userUuid) => '/auth/admin/users/$userUuid/sessions/revoke';
  static String revokeAllUserSessions(String userUuid) => '/auth/admin/users/$userUuid/sessions/revoke-all';
  static const String auditLogs = '/auth/admin/audit-logs';
  static const String auditLogsSearch = '/auth/admin/audit-logs/search';
  static const String configHealth = '/auth/admin/config/health';

  // Projects
  static const String projects = '/projects';
  static String projectDetail(String projectUuid) => '/projects/$projectUuid';
  static String projectVersions(String projectUuid) => '/projects/$projectUuid/versions';
  static String projectVersionDetail(String projectUuid, String versionUuid) => '/projects/$projectUuid/versions/$versionUuid';

  // Forms
  static String forms(String projectUuid) => '/projects/$projectUuid/forms';
  static String formDetail(String projectUuid, String formUuid) => '/projects/$projectUuid/forms/$formUuid';
  static String formVersions(String projectUuid, String formUuid) => '/projects/$projectUuid/forms/$formUuid/versions';
  static String formVersionDetail(String projectUuid, String formUuid, String versionUuid) => '/projects/$projectUuid/forms/$formUuid/versions/$versionUuid';
  static String submitFormWorkflow(String projectUuid, String formUuid) => '/projects/$projectUuid/forms/$formUuid/workflow/submit';
  static String reviewFormWorkflow(String projectUuid, String formUuid) => '/projects/$projectUuid/forms/$formUuid/workflow/review';
  static String approveFormWorkflow(String projectUuid, String formUuid) => '/projects/$projectUuid/forms/$formUuid/workflow/approve';
  static String effectiveUi(String projectUuid, String formUuid) => '/projects/$projectUuid/forms/$formUuid/ui/effective';

  // Sections
  static String sections(String projectUuid, String formUuid) => '/projects/$projectUuid/forms/$formUuid/sections';
  static String sectionDetail(String projectUuid, String formUuid, String sectionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid';
  static String sectionVersions(String projectUuid, String formUuid, String sectionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/versions';
  static String sectionVersionDetail(String projectUuid, String formUuid, String sectionUuid, String versionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/versions/$versionUuid';

  // Questions
  static String questions(String projectUuid, String formUuid, String sectionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/questions';
  static String questionDetail(String projectUuid, String formUuid, String sectionUuid, String questionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/questions/$questionUuid';
  static String questionVersions(String projectUuid, String formUuid, String sectionUuid, String questionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/questions/$questionUuid/versions';
  static String questionVersionDetail(String projectUuid, String formUuid, String sectionUuid, String questionUuid, String versionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/questions/$questionUuid/versions/$versionUuid';

  // Choices
  static String choices(String projectUuid, String formUuid, String sectionUuid, String questionUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/questions/$questionUuid/choices';
  static String choiceDetail(String projectUuid, String formUuid, String sectionUuid, String questionUuid, String choiceUuid) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/questions/$questionUuid/choices/$choiceUuid';

  // Actions
  static String triggerAction(String projectUuid, String formUuid, String sectionUuid, String questionUuid, String actionId) => '/projects/$projectUuid/forms/$formUuid/sections/$sectionUuid/questions/$questionUuid/actions/$actionId/trigger';
  static String actionExecutions(String projectUuid, String formUuid, String responseUuid) => '/projects/$projectUuid/forms/$formUuid/responses/$responseUuid/action-executions';

  // Conditions
  static const String conditionsMetadata = '/conditions/metadata';
  static const String conditionsOperatorsMetadata = '/conditions/operators/metadata';
  static const String testCondition = '/conditions/test';
  static const String testBatchConditions = '/conditions/test/batch';
  static const String cacheMetrics = '/conditions/cache/metrics';
  static String invalidateCache(String conditionUuid) => '/conditions/cache/invalidate/$conditionUuid';
  static String usageCondition(String conditionUuid) => '/conditions/usage/$conditionUuid';
  static String impactCondition(String conditionUuid) => '/conditions/impact/$conditionUuid';
  static const String monitoringGraph = '/conditions/monitoring/graph';
  static const String monitoringHeatmap = '/conditions/monitoring/heatmap';
  static const String monitoringUnused = '/conditions/monitoring/unused';
  static const String monitoringMostUsed = '/conditions/monitoring/most-used';
  static const String monitoringEvaluationStats = '/conditions/monitoring/evaluation-stats';
  static const String presets = '/conditions/presets';
  static const String presetsImport = '/conditions/presets/import';
  static const String presetsExport = '/conditions/presets/export';
  static String approvalTransition(String conditionUuid) => '/conditions/$conditionUuid/approval/transition';
  static String approvalRollback(String conditionUuid) => '/conditions/$conditionUuid/approval/rollback';
  static String conditionVersions(String conditionUuid) => '/conditions/$conditionUuid/versions';
  static String recordConditionVersion(String conditionUuid) => '/conditions/$conditionUuid/versions/record';
  static String restoreConditionVersion(String conditionUuid) => '/conditions/$conditionUuid/versions/restore';
  static const String bulkCreateConditions = '/conditions/bulk/create';
  static const String bulkUpdateConditions = '/conditions/bulk/update';
  static const String bulkDeleteConditions = '/conditions/bulk/delete';
  static const String bulkValidateConditions = '/conditions/bulk/validate';
  static const String bulkTestConditions = '/conditions/bulk/test';
  static const String bulkImportConditions = '/conditions/bulk/import';
  static const String bulkExportConditions = '/conditions/bulk/export';
  static const String asyncEvaluateCondition = '/conditions/async/evaluate';
  static String asyncJobStatus(String jobId) => '/conditions/async/$jobId';

  // UI Templates
  static const String themeTemplates = '/ui/theme-templates';
  static String publishThemeTemplate(String templateUuid, String revisionUuid) => '/ui/theme-templates/$templateUuid/revisions/$revisionUuid/publish';
  static const String layoutTemplates = '/ui/layout-templates';
  static String publishLayoutTemplate(String templateUuid, String revisionUuid) => '/ui/layout-templates/$templateUuid/revisions/$revisionUuid/publish';

  // Admin Rate Limits
  static const String rateLimitConfigs = '/admin/rate-limits/configs';
  static String rateLimitConfigDetail(String ruleId) => '/admin/rate-limits/configs/$ruleId';
  static String resetRateLimit(String ruleId) => '/admin/rate-limits/configs/$ruleId/reset';
  static const String bulkUpdateRateLimits = '/admin/rate-limits/bulk/update';
  static const String bulkResetRateLimits = '/admin/rate-limits/bulk/reset';
  static const String rateLimitLogs = '/admin/rate-limits/logs';
  static const String rateLimitStatus = '/admin/rate-limits/status';
}
