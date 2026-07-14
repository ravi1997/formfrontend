# Backend Frontend Parity Matrix

Source of truth:
- Backend repo: `/home/ravi/workspace/new/form`
- Frontend repo: `/home/ravi/workspace/new/formfrontend`

This matrix is based on the current frontend code and the backend surface described in the plan/attachment.
Statuses are intentionally conservative:
- `aligned` = the frontend has a real implementation and tests cover the route/surface
- `partial` = the frontend exists, but the surface is incomplete or mostly read-only
- `missing` = no meaningful frontend implementation yet

## 1. Contract and shell layer

| Area | Frontend status | Evidence | Next action |
|---|---|---|---|
| App bootstrap | aligned | `lib/main.dart`, `lib/app/app.dart` | Keep stable |
| Router | aligned | `lib/app/router/app_router.dart`, `lib/app/router/route_names.dart` | Keep route names stable |
| API client | aligned | `lib/core/api/api_client.dart`, `lib/core/api/api_endpoints.dart` | Add contract tests as backend changes |
| Auth/session storage | aligned | `lib/core/auth/token_manager.dart`, `lib/core/auth/session_store.dart`, `lib/core/state/auth_state.dart` | Verify refresh/revoke behavior against backend |
| App shell navigation | aligned | `lib/app/shell/main_shell.dart` | Keep shell tabs in sync with backend domains |

## 2. Auth and identity

| Area | Frontend status | Evidence | Next action |
|---|---|---|---|
| Login/register | aligned | `lib/features/auth/presentation/login_page.dart`, `register_page.dart`, `lib/features/auth/data/auth_api.dart` | Verify payload/validation parity |
| Me/profile | aligned | `lib/features/auth/presentation/me_page.dart`, `test/me_page_test.dart` | Keep `GET /auth/me` contract in sync |
| Sessions | aligned | `lib/features/auth/presentation/sessions_page.dart`, auth state/session state | Verify revoke/logout-all semantics |
| Admin user sessions | aligned | `lib/features/admin/presentation/admin_user_sessions_page.dart`, `test/admin_user_sessions_page_test.dart` | Verify admin-only access and response shape |
| Audit logs | aligned | `lib/features/admin/presentation/admin_audit_logs_page.dart`, `test/admin_audit_logs_page_test.dart` | Confirm search/filter coverage |
| Config health | aligned | `lib/features/admin/presentation/admin_config_health_page.dart` | Keep backend checks current |

## 3. Core resource hierarchy

| Area | Frontend status | Evidence | Next action |
|---|---|---|---|
| Projects list/detail | aligned | `lib/features/projects/presentation/projects_list_page.dart`, `project_detail_page.dart`, `project_versions_page.dart` | Add edit/version workflow parity if backend changes |
| Forms list/detail | aligned | `lib/features/forms/presentation/forms_list_page.dart`, `form_detail_page.dart`, `form_versions_page.dart` | Verify CRUD and delete semantics |
| Form edit | aligned | `lib/features/forms/presentation/form_edit_page.dart`, `lib/app/router/app_router.dart`, `test/form_edit_page_test.dart` | Confirm full backend patch payload coverage |
| Form workflow | aligned | `lib/features/forms/presentation/form_workflow_page.dart` | Keep submit/review/approve semantics aligned |
| Effective UI | aligned | `lib/features/forms/presentation/form_effective_ui_page.dart`, `lib/features/forms/presentation/widgets/effective_ui_form.dart` | Verify payload shaping against backend renderer |
| Sections list/detail/edit/version | aligned | `lib/features/sections/presentation/sections_list_page.dart`, `section_detail_page.dart`, `section_edit_page.dart`, `section_versions_page.dart` | Verify version linkage and repeatable bounds |
| Questions list/detail/edit/version | aligned | `lib/features/questions/presentation/questions_list_page.dart`, `question_detail_page.dart`, `question_edit_page.dart`, `question_versions_page.dart` | Verify action/question constraints |
| Choices list/edit | aligned | `lib/features/choices/presentation/choices_list_page.dart`, `choice_edit_page.dart` | Verify nested choice CRUD payloads |

## 4. Workflow and response execution

| Area | Frontend status | Evidence | Next action |
|---|---|---|---|
| Response submission | aligned | `lib/features/responses/presentation/response_submission_page.dart` | Verify it submits backend-native payloads only |
| Action executions | aligned | `lib/features/responses/presentation/action_executions_page.dart` | Verify response/action history shape |
| Workflow actions | aligned | `lib/features/workflows/presentation/workflow_actions_page.dart` | Keep route params and permissions accurate |

## 5. Conditions

| Area | Frontend status | Evidence | Next action |
|---|---|---|---|
| Condition test | aligned | `lib/features/conditions/presentation/condition_test_page.dart` | Verify metadata/operator payloads |
| Batch test | aligned | `lib/features/conditions/presentation/condition_batch_test_page.dart`, `test/condition_workflow_pages_test.dart` | Confirm backend batch semantics and validation |
| Presets | aligned | `lib/features/conditions/presentation/condition_presets_page.dart`, `test/condition_workflow_pages_test.dart` | Verify import/export and CRUD details |
| Versions | aligned | `lib/features/conditions/presentation/condition_versions_page.dart`, `test/condition_versions_and_system_pages_test.dart` | Verify restore/record semantics |
| Approval | aligned | `lib/features/conditions/presentation/condition_approval_page.dart`, `test/condition_workflow_pages_test.dart` | Confirm operator role gating |
| Monitoring | aligned | `lib/features/conditions/presentation/condition_monitoring_page.dart`, `test/condition_monitoring_page_test.dart` | Confirm graph/heatmap/metrics payloads |
| Async evaluate | aligned | `lib/features/conditions/presentation/condition_async_page.dart`, `test/condition_workflow_pages_test.dart` | Verify async job status model |

## 6. UI templates

| Area | Frontend status | Evidence | Next action |
|---|---|---|---|
| Theme templates | aligned | `lib/features/ui_templates/presentation/theme_templates_page.dart` | Verify publish payloads and revision selection |
| Layout templates | aligned | `lib/features/ui_templates/presentation/layout_templates_page.dart` | Verify publish payloads and revision selection |

## 7. System and ops

| Area | Frontend status | Evidence | Next action |
|---|---|---|---|
| Health | aligned | `lib/features/system/presentation/health_page.dart` | Keep endpoint paths synchronized |
| Readiness | aligned | `lib/features/system/presentation/readiness_page.dart` | Keep endpoint paths synchronized |
| Metrics | aligned | `lib/features/system/presentation/metrics_page.dart` | Keep endpoint paths synchronized |
| Schema echo | aligned | `lib/features/system/presentation/schema_echo_page.dart`, `test/system_pages_test.dart` | Verify backend auth requirement and payload shape |
| Admin dashboard | aligned | `lib/features/admin/presentation/admin_dashboard_page.dart`, `test/admin_dashboard_page_test.dart` | Verify aggregated data sources and privilege checks |
| Rate limits | aligned | `lib/features/admin/presentation/admin_rate_limits_page.dart` | Verify CRUD/reset/log/status coverage |
| Organisation management | aligned | `lib/features/admin/presentation/organisation_management_page.dart`, `test/organisation_management_page_test.dart` | Confirm whether backend keeps this surface stable |

## 8. Data model and client gaps

### Aligned or mostly aligned
- Endpoint map exists in `lib/core/api/api_endpoints.dart`
- Centralized client exists in `lib/core/api/api_client.dart`
- Route names are explicit in `lib/app/router/route_names.dart`
- Shell navigation already exposes backend domains in `lib/app/shell/main_shell.dart`

### Still worth tightening
- Auth refresh/revoke edge cases
- Response payload coercion and validation
- Full parity for conditions, templates, and admin surfaces
- Any route that exists in the shell but still has incomplete request/response handling

## 9. Recommended execution order

1. Auth/session contract hardening
2. Projects and forms CRUD parity
3. Sections, questions, and choices payload parity
4. Response submission and workflow execution parity
5. Conditions feature depth
6. Admin and ops surfaces
7. Contract tests and docs sync

## 10. Current validation

Verified in this workspace:
- `flutter analyze`
- `flutter test test/api_contract_test.dart`
- `flutter test test/widget_test.dart`
