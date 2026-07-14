
# Flutter Frontend Plan

## Executive Summary

This repository exposes a Flask/OpenAPI backend for:

- JWT auth and session management
- Hierarchical project -> form -> section -> question -> choice CRUD
- Form workflow transitions
- UI template creation/publishing
- Condition authoring, testing, analytics, presets, approval/versioning, async evaluation
- Admin auth/session/audit/config health operations
- Admin rate-limit operations
- System health, readiness, metrics, and schema echo validation

There is an existing Flutter app in this repository. The frontend should continue to evolve as the backend client of record, keep the backend API as the source of truth, and tighten contract alignment where the current app already overlaps the backend surface.

This plan focuses on modules, file paths, pages, navigation, state, data flow, and backend integration. It deliberately excludes UI/visual design except where the design system must remain consistent with the product brand.

## Current Implementation Status

The current Flutter app already covers a meaningful portion of the backend-shaped surface:

- app shell, auth shell, router, and route names
- centralized API client, endpoint map, auth token storage, and auth/session state
- project, form, section, question, and choice feature slices
- workflow, response submission, admin, system, condition, and UI template feature slices
- effective UI rendering for forms

Verified runtime checks currently passing in this workspace:

- `flutter analyze`
- `flutter test test/api_contract_test.dart`
- `flutter test test/widget_test.dart`

## Product Alignment

- Product identity: `A.D.I.Y.O.G.I`
- Product meaning: structured intelligence system
- Public lifecycle: Awareness -> Data -> Interpretation -> Yield -> Observation -> Generation -> Insight
- UI role: support structured capture, transformation, and insight generation
- Visual system source: `design.md`
- Voice and positioning source: `brand.md`

The frontend should present backend capabilities as parts of a single lifecycle rather than as isolated admin pages or CRUD screens.

## Backend Feature Inventory

### System / operational

- `GET /api/v1/health`
- `GET /api/v1/liveness`
- `GET /api/v1/readiness`
- `GET /api/v1/ready`
- `GET /api/v1/metrics`
- `POST /api/v1/schemas/echo-form`

### Authentication and sessions

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`
- `GET /api/v1/auth/me`
- `GET /api/v1/auth/sessions`
- `POST /api/v1/auth/sessions/revoke`
- `POST /api/v1/auth/logout-all`

### Admin auth and security operations

- `GET /api/v1/auth/admin/users/<user_uuid>/sessions`
- `POST /api/v1/auth/admin/users/<user_uuid>/sessions/revoke`
- `POST /api/v1/auth/admin/users/<user_uuid>/sessions/revoke-all`
- `GET /api/v1/auth/admin/audit-logs`
- `GET /api/v1/auth/admin/audit-logs/search`
- `GET /api/v1/auth/admin/config/health`

### Project management

- `POST /api/v1/projects`
- `GET /api/v1/projects`
- `GET /api/v1/projects/<project_uuid>`
- `PATCH /api/v1/projects/<project_uuid>`
- `DELETE /api/v1/projects/<project_uuid>`
- `POST /api/v1/projects/<project_uuid>/versions`
- `PATCH /api/v1/projects/<project_uuid>/versions/<version_uuid>`

### Form management

- `POST /api/v1/projects/<project_uuid>/forms`
- `GET /api/v1/projects/<project_uuid>/forms`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>`
- `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>`
- `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>`
- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/versions`
- `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/versions/<version_uuid>`
- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/workflow/submit`
- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/workflow/review`
- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/workflow/approve`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/ui/effective`

### Section management

- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>`
- `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>`
- `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>`
- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/versions`
- `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/versions/<version_uuid>`

### Question management

- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>`
- `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>`
- `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>`
- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/versions`
- `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/versions/<version_uuid>`

### Choice management

- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices/<choice_uuid>`
- `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices/<choice_uuid>`
- `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices/<choice_uuid>`

### Action execution

- `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/actions/<action_id>/trigger`
- `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/responses/<response_uuid>/action-executions`

### Conditions

- `GET /api/v1/conditions/metadata`
- `GET /api/v1/conditions/operators/metadata`
- `POST /api/v1/conditions/test`
- `POST /api/v1/conditions/test/batch`
- `GET /api/v1/conditions/cache/metrics`
- `POST /api/v1/conditions/cache/invalidate/<condition_uuid>`
- `GET /api/v1/conditions/usage/<condition_uuid>`
- `POST /api/v1/conditions/impact/<condition_uuid>`
- `GET /api/v1/conditions/monitoring/graph`
- `GET /api/v1/conditions/monitoring/heatmap`
- `GET /api/v1/conditions/monitoring/unused`
- `GET /api/v1/conditions/monitoring/most-used`
- `GET /api/v1/conditions/monitoring/evaluation-stats`
- `POST /api/v1/conditions/presets`
- `GET /api/v1/conditions/presets`
- `POST /api/v1/conditions/presets/import`
- `GET /api/v1/conditions/presets/export`
- `POST /api/v1/conditions/<condition_uuid>/approval/transition`
- `POST /api/v1/conditions/<condition_uuid>/approval/rollback`
- `GET /api/v1/conditions/<condition_uuid>/versions`
- `POST /api/v1/conditions/<condition_uuid>/versions/record`
- `POST /api/v1/conditions/<condition_uuid>/versions/restore`
- `POST /api/v1/conditions/bulk/create`
- `PATCH /api/v1/conditions/bulk/update`
- `DELETE /api/v1/conditions/bulk/delete`
- `POST /api/v1/conditions/bulk/validate`
- `POST /api/v1/conditions/bulk/test`
- `POST /api/v1/conditions/bulk/import`
- `GET /api/v1/conditions/bulk/export`
- `POST /api/v1/conditions/async/evaluate`
- `GET /api/v1/conditions/async/<job_id>`

### UI templates

- `POST /api/v1/ui/theme-templates`
- `POST /api/v1/ui/theme-templates/<template_uuid>/revisions/<revision_uuid>/publish`
- `POST /api/v1/ui/layout-templates`
- `POST /api/v1/ui/layout-templates/<template_uuid>/revisions/<revision_uuid>/publish`

### Admin rate limits

- `POST /api/v1/admin/rate-limits/configs`
- `GET /api/v1/admin/rate-limits/configs`
- `GET /api/v1/admin/rate-limits/configs/<rule_id>`
- `PATCH /api/v1/admin/rate-limits/configs/<rule_id>`
- `POST /api/v1/admin/rate-limits/configs/<rule_id>/reset`
- `DELETE /api/v1/admin/rate-limits/configs/<rule_id>`
- `POST /api/v1/admin/rate-limits/bulk/update`
- `POST /api/v1/admin/rate-limits/bulk/reset`
- `GET /api/v1/admin/rate-limits/logs`
- `GET /api/v1/admin/rate-limits/status`

## Design System Integration

The Flutter client should follow the validated monochrome system in `design.md`.

### Visual rules

- Use `Lora` for display and section-level emphasis.
- Use `Instrument Sans` for body, labels, and controls.
- Use `Inter` only for micro UI text and badges.
- Keep surfaces monochrome and neutral.
- Use rounded corners consistently from the radius token set.
- Use the validated spacing scale without inventing new spacing rhythm.
- Use depth sparingly and only from the documented shadow tokens.

### UI behavior rules

- Prioritize hierarchy over decoration.
- Treat forms as structured input surfaces, not marketing pages.
- Treat workflow, condition, and admin screens as operational surfaces.
- Keep copy short, declarative, and neutral.
- Avoid language that implies hype, novelty, or emotional branding.

## Flutter Module Structure

Recommended top-level Flutter package layout:

```text
lib/
  app/
    app.dart
    router/
    bootstrap/
    shell/
  core/
    api/
    auth/
    config/
    errors/
    routing/
    state/
    models/
    validation/
    storage/
    utils/
  features/
    auth/
    dashboard/
    projects/
    forms/
    sections/
    questions/
    choices/
    workflows/
    ui_templates/
    conditions/
    admin/
    system/
    responses/
    shared_ui/   # non-visual shared widgets only if needed for forms/data entry
```

Feature boundaries:

- `auth`: login, register, session management, profile
- `projects`: project list/detail/create/edit/versioning
- `forms`: form list/detail/create/edit/versioning/effective UI config/workflow
- `sections`: section list/detail/create/edit/versioning
- `questions`: question list/detail/create/edit/versioning
- `choices`: choice list/detail/create/edit/delete
- `workflows`: submit/review/approve actions and workflow history
- `ui_templates`: theme and layout template create/publish and binding into forms
- `conditions`: condition metadata, testing, presets, versions, approval, analytics, async evaluation, cache metrics
- `admin`: admin-only session/audit/config-health and rate-limit management
- `system`: health, readiness, metrics, schema echo validation
- `responses`: action execution history for form responses

## Proposed File Paths

### App bootstrap and routing

- `lib/app/app.dart`
- `lib/app/router/app_router.dart`
- `lib/app/router/route_names.dart`
- `lib/app/shell/auth_shell.dart`
- `lib/app/shell/main_shell.dart`

### Core platform layers

- `lib/core/api/api_client.dart`
- `lib/core/api/api_endpoints.dart`
- `lib/core/api/api_result.dart`
- `lib/core/api/api_interceptors.dart`
- `lib/core/auth/auth_repository.dart`
- `lib/core/auth/session_store.dart`
- `lib/core/auth/token_manager.dart`
- `lib/core/config/app_config.dart`
- `lib/core/errors/api_error.dart`
- `lib/core/routing/route_guards.dart`
- `lib/core/state/auth_state.dart`
- `lib/core/state/session_state.dart`
- `lib/core/state/current_user_state.dart`
- `lib/core/state/pagination_state.dart`
- `lib/core/storage/secure_token_storage.dart`
- `lib/core/validation/validators.dart`
- `lib/core/models/pagination.dart`
- `lib/core/models/error_payload.dart`

### Feature folders

- `lib/features/auth/data/auth_api.dart`
- `lib/features/auth/data/auth_models.dart`
- `lib/features/auth/data/auth_repository_impl.dart`
- `lib/features/auth/presentation/login_page.dart`
- `lib/features/auth/presentation/register_page.dart`
- `lib/features/auth/presentation/me_page.dart`
- `lib/features/auth/presentation/sessions_page.dart`
- `lib/features/projects/data/projects_api.dart`
- `lib/features/projects/data/projects_models.dart`
- `lib/features/projects/data/projects_repository_impl.dart`
- `lib/features/projects/presentation/projects_list_page.dart`
- `lib/features/projects/presentation/project_detail_page.dart`
- `lib/features/projects/presentation/project_form_page.dart`
- `lib/features/projects/presentation/project_versions_page.dart`
- `lib/features/forms/data/forms_api.dart`
- `lib/features/forms/data/forms_models.dart`
- `lib/features/forms/data/forms_repository_impl.dart`
- `lib/features/forms/presentation/forms_list_page.dart`
- `lib/features/forms/presentation/form_detail_page.dart`
- `lib/features/forms/presentation/form_edit_page.dart`
- `lib/features/forms/presentation/form_versions_page.dart`
- `lib/features/forms/presentation/form_workflow_page.dart`
- `lib/features/forms/presentation/form_effective_ui_page.dart`
- `lib/features/sections/...`
- `lib/features/questions/...`
- `lib/features/choices/...`
- `lib/features/workflows/...`
- `lib/features/ui_templates/data/ui_templates_api.dart`
- `lib/features/ui_templates/data/ui_templates_models.dart`
- `lib/features/ui_templates/presentation/theme_templates_page.dart`
- `lib/features/ui_templates/presentation/layout_templates_page.dart`
- `lib/features/ui_templates/presentation/template_detail_page.dart`
- `lib/features/conditions/data/conditions_api.dart`
- `lib/features/conditions/data/conditions_models.dart`
- `lib/features/conditions/presentation/condition_test_page.dart`
- `lib/features/conditions/presentation/condition_batch_test_page.dart`
- `lib/features/conditions/presentation/condition_presets_page.dart`
- `lib/features/conditions/presentation/condition_versions_page.dart`
- `lib/features/conditions/presentation/condition_approval_page.dart`
- `lib/features/conditions/presentation/condition_monitoring_page.dart`
- `lib/features/conditions/presentation/condition_async_page.dart`
- `lib/features/admin/data/admin_api.dart`
- `lib/features/admin/presentation/admin_dashboard_page.dart`
- `lib/features/admin/presentation/admin_audit_logs_page.dart`
- `lib/features/admin/presentation/admin_user_sessions_page.dart`
- `lib/features/admin/presentation/admin_config_health_page.dart`
- `lib/features/admin/presentation/admin_rate_limits_page.dart`
- `lib/features/system/data/system_api.dart`
- `lib/features/system/presentation/health_page.dart`
- `lib/features/system/presentation/metrics_page.dart`
- `lib/features/system/presentation/readiness_page.dart`
- `lib/features/system/presentation/schema_echo_page.dart`
- `lib/features/responses/data/responses_api.dart`
- `lib/features/responses/presentation/action_executions_page.dart`

## Page Inventory

### Public pages

- `LoginPage`
- `RegisterPage`
- `HealthPage`
- `ReadinessPage`
- `MetricsPage`
- `SchemaEchoPage`

### Authenticated pages

- `MePage`
- `SessionsPage`
- `ProjectsListPage`
- `ProjectDetailPage`
- `ProjectFormPage`
- `ProjectVersionsPage`
- `FormsListPage`
- `FormDetailPage`
- `FormEditPage`
- `FormVersionsPage`
- `FormWorkflowPage`
- `FormEffectiveUiPage`
- `SectionsListPage`
- `SectionDetailPage`
- `SectionEditPage`
- `SectionVersionsPage`
- `QuestionsListPage`
- `QuestionDetailPage`
- `QuestionEditPage`
- `QuestionVersionsPage`
- `ChoicesListPage`
- `ChoiceEditPage`
- `ActionExecutionsPage`
- `ConditionTestPage`
- `ConditionBatchTestPage`
- `ConditionPresetsPage`
- `ConditionVersionsPage`
- `ConditionApprovalPage`
- `ConditionMonitoringPage`
- `ConditionAsyncPage`
- `TemplateDetailPage`

### Admin-only pages

- `AdminDashboardPage`
- `AdminAuditLogsPage`
- `AdminUserSessionsPage`
- `AdminConfigHealthPage`
- `AdminRateLimitsPage`

### Role-limited pages

- `ProjectDetailPage` and nested project editing pages: visible only to users who can read/write the project under RBAC
- `FormEditPage`, `FormWorkflowPage`, `SectionEditPage`, `QuestionEditPage`, `ChoiceEditPage`: require resource access and usually edit authority
- `ConditionApprovalPage`: intended for condition maintainers or admin/operators
- `TemplateDetailPage`: publish actions restricted to template admins or super admins
- `ActionExecutionsPage`: should be visible to users who can access the owning form/response

## Route Map

Use nested routes so the navigation mirrors backend hierarchy.

```text
/login
/register
/me
/sessions
/system/health
/system/readiness
/system/metrics
/system/schema-echo

/projects
/projects/:projectUuid
/projects/:projectUuid/edit
/projects/:projectUuid/versions
/projects/:projectUuid/forms
/projects/:projectUuid/forms/new
/projects/:projectUuid/forms/:formUuid
/projects/:projectUuid/forms/:formUuid/edit
/projects/:projectUuid/forms/:formUuid/versions
/projects/:projectUuid/forms/:formUuid/workflow
/projects/:projectUuid/forms/:formUuid/ui
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid/edit
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid/versions
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid/questions/:questionUuid
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid/questions/:questionUuid/edit
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid/questions/:questionUuid/versions
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid/questions/:questionUuid/choices
/projects/:projectUuid/forms/:formUuid/sections/:sectionUuid/questions/:questionUuid/choices/:choiceUuid/edit
/projects/:projectUuid/forms/:formUuid/responses/:responseUuid/action-executions

/conditions
/conditions/:conditionUuid
/conditions/:conditionUuid/test
/conditions/:conditionUuid/batch-test
/conditions/:conditionUuid/versions
/conditions/:conditionUuid/approval
/conditions/:conditionUuid/monitoring
/conditions/async
/conditions/presets

/templates/theme
/templates/layout
/templates/theme/:templateUuid
/templates/layout/:templateUuid

/admin
/admin/audit-logs
/admin/users/:userUuid/sessions
/admin/config-health
/admin/rate-limits
```

## Backend Endpoint Map

### Auth pages

- `LoginPage`
  - `POST /api/v1/auth/login`
  - Validation: email required and valid email; password required
  - Auth: none
- `RegisterPage`
  - `POST /api/v1/auth/register`
  - Validation: name required; email valid; password minimum length 8; optional designation, phone, device_name
  - Auth: none
- `MePage`
  - `GET /api/v1/auth/me`
  - Auth: access token
- `SessionsPage`
  - `GET /api/v1/auth/sessions`
  - `POST /api/v1/auth/sessions/revoke`
  - `POST /api/v1/auth/logout-all`
  - Validation: session_uuid required for revoke; keep_current boolean for logout-all
  - Auth: access token

### Project pages

- `ProjectsListPage`
  - `GET /api/v1/projects`
  - `POST /api/v1/projects` for creation
  - Validation: UUID, name, versions, role lists, tags, status
  - Auth: access token
  - Role: project read requires RBAC; create likely requires elevated/admin privileges
- `ProjectDetailPage`
  - `GET /api/v1/projects/<project_uuid>`
  - `PATCH /api/v1/projects/<project_uuid>`
  - `DELETE /api/v1/projects/<project_uuid>`
  - `POST /api/v1/projects/<project_uuid>/versions`
  - `PATCH /api/v1/projects/<project_uuid>/versions/<version_uuid>`
  - Auth: access token
  - Role: read/write governed by project RBAC

### Form pages

- `FormsListPage`
  - `GET /api/v1/projects/<project_uuid>/forms`
  - `POST /api/v1/projects/<project_uuid>/forms`
  - Auth: access token
  - Role: project access plus write permission for create
- `FormDetailPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>`
  - `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/ui/effective`
  - Auth: access token
- `FormEditPage`
  - `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>`
  - Validation: requires reviewer/approver list consistency when those flags are enabled
  - Auth: access token
  - Role: edit authority
- `FormVersionsPage`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/versions`
  - `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/versions/<version_uuid>`
  - Auth: access token
- `FormWorkflowPage`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/workflow/submit`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/workflow/review`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/workflow/approve`
  - Auth: access token
  - Role: submit/review/approve rights per RBAC and workflow config
- `FormEffectiveUiPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/ui/effective`
  - Auth: access token

### Section pages

- `SectionsListPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections?version_uuid=...`
  - Validation: repeatable count bounds, version_uuid linkage
  - Auth: access token
- `SectionDetailPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>`
  - `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>`
  - Auth: access token
- `SectionEditPage`
  - `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>`
  - Validation: min_repeatable_count <= max_repeatable_count; version payloads if used
  - Auth: access token
- `SectionVersionsPage`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/versions`
  - `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/versions/<version_uuid>`
  - Auth: access token

### Question pages

- `QuestionsListPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions?version_uuid=...`
  - Validation: question type, label, repeatable bounds, action requirements
  - Auth: access token
- `QuestionDetailPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>`
  - `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>`
  - Auth: access token
- `QuestionEditPage`
  - `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>`
  - Validation: action questions require actionType and actionLabel unless explicit action definitions exist; repeatable bounds; choices structure
  - Auth: access token
- `QuestionVersionsPage`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/versions`
  - `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/versions/<version_uuid>`
  - Auth: access token

### Choice pages

- `ChoicesListPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices`
  - Auth: access token
- `ChoiceEditPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices/<choice_uuid>`
  - `PATCH /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices/<choice_uuid>`
  - `DELETE /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/choices/<choice_uuid>`
  - Auth: access token

### Action execution page

- `ActionExecutionsPage`
  - `GET /api/v1/projects/<project_uuid>/forms/<form_uuid>/responses/<response_uuid>/action-executions`
  - `POST /api/v1/projects/<project_uuid>/forms/<form_uuid>/sections/<section_uuid>/questions/<question_uuid>/actions/<action_id>/trigger`
  - Validation: confirmation required when action demands it; response_uuid required for response-bound steps; idempotency key supported
  - Auth: access token

### Conditions pages

- `ConditionTestPage`
  - `POST /api/v1/conditions/test`
  - `GET /api/v1/conditions/metadata`
  - `GET /api/v1/conditions/operators/metadata`
  - Auth: access token
- `ConditionBatchTestPage`
  - `POST /api/v1/conditions/test/batch`
  - Auth: access token
- `ConditionPresetsPage`
  - `GET /api/v1/conditions/presets`
  - `POST /api/v1/conditions/presets`
  - `POST /api/v1/conditions/presets/import`
  - `GET /api/v1/conditions/presets/export`
  - Auth: access token
- `ConditionVersionsPage`
  - `GET /api/v1/conditions/<condition_uuid>/versions`
  - `POST /api/v1/conditions/<condition_uuid>/versions/record`
  - `POST /api/v1/conditions/<condition_uuid>/versions/restore`
  - Auth: access token
- `ConditionApprovalPage`
  - `POST /api/v1/conditions/<condition_uuid>/approval/transition`
  - `POST /api/v1/conditions/<condition_uuid>/approval/rollback`
  - Auth: access token
- `ConditionMonitoringPage`
  - `GET /api/v1/conditions/monitoring/graph`
  - `GET /api/v1/conditions/monitoring/heatmap`
  - `GET /api/v1/conditions/monitoring/unused`
  - `GET /api/v1/conditions/monitoring/most-used`
  - `GET /api/v1/conditions/monitoring/evaluation-stats`
  - `GET /api/v1/conditions/cache/metrics`
  - `POST /api/v1/conditions/cache/invalidate/<condition_uuid>`
  - `POST /api/v1/conditions/impact/<condition_uuid>`
  - `GET /api/v1/conditions/usage/<condition_uuid>`
  - Auth: access token
- `ConditionAsyncPage`
  - `POST /api/v1/conditions/async/evaluate`
  - `GET /api/v1/conditions/async/<job_id>`
  - Auth: access token

### Template pages

- `ThemeTemplatesPage`
  - `POST /api/v1/ui/theme-templates`
  - `POST /api/v1/ui/theme-templates/<template_uuid>/revisions/<revision_uuid>/publish`
  - Auth: access token
  - Role: template admin or super admin for publish
- `LayoutTemplatesPage`
  - `POST /api/v1/ui/layout-templates`
  - `POST /api/v1/ui/layout-templates/<template_uuid>/revisions/<revision_uuid>/publish`
  - Auth: access token
  - Role: template admin or super admin for publish

### Admin pages

- `AdminDashboardPage`
  - aggregates auth/admin/system status endpoints
  - `GET /api/v1/auth/admin/config/health`
  - `GET /api/v1/admin/rate-limits/status`
  - `GET /api/v1/metrics`
  - `GET /api/v1/readiness`
  - Auth: access token
  - Role: super admin or equivalent admin privilege
- `AdminAuditLogsPage`
  - `GET /api/v1/auth/admin/audit-logs`
  - `GET /api/v1/auth/admin/audit-logs/search`
  - Auth: access token
  - Role: admin
- `AdminUserSessionsPage`
  - `GET /api/v1/auth/admin/users/<user_uuid>/sessions`
  - `POST /api/v1/auth/admin/users/<user_uuid>/sessions/revoke`
  - `POST /api/v1/auth/admin/users/<user_uuid>/sessions/revoke-all`
  - Auth: access token
  - Role: admin
- `AdminConfigHealthPage`
  - `GET /api/v1/auth/admin/config/health`
  - Auth: access token
  - Role: admin
- `AdminRateLimitsPage`
  - `GET /api/v1/admin/rate-limits/configs`
  - `POST /api/v1/admin/rate-limits/configs`
  - `GET /api/v1/admin/rate-limits/configs/<rule_id>`
  - `PATCH /api/v1/admin/rate-limits/configs/<rule_id>`
  - `POST /api/v1/admin/rate-limits/configs/<rule_id>/reset`
  - `DELETE /api/v1/admin/rate-limits/configs/<rule_id>`
  - `POST /api/v1/admin/rate-limits/bulk/update`
  - `POST /api/v1/admin/rate-limits/bulk/reset`
  - `GET /api/v1/admin/rate-limits/logs`
  - `GET /api/v1/admin/rate-limits/status`
  - Auth: access token
  - Role: admin

### System pages

- `HealthPage`
  - `GET /api/v1/health`
- `ReadinessPage`
  - `GET /api/v1/readiness`
  - `GET /api/v1/ready`
- `MetricsPage`
  - `GET /api/v1/metrics`
- `SchemaEchoPage`
  - `POST /api/v1/schemas/echo-form`
  - auth: likely public unless backend requires otherwise; verify during implementation

## Auth and Role Mapping

### Public

- Registration and login
- System health/readiness/metrics pages if you choose to expose them without auth
- Schema echo validation if backend confirms no auth requirement

### Authenticated

- All project/form/section/question/choice/action execution pages
- Self session management
- Condition testing, presets, versioning, async evaluation, monitoring
- Template creation and browsing

### Admin-only

- Admin session management for other users
- Audit logs and audit search
- Config health
- Rate-limit management

### Role-limited and RBAC-sensitive

- Project access is filtered by backend RBAC checks in `GET /api/v1/projects`
- Project CRUD should only be enabled when the user has write permissions
- Form workflow actions depend on workflow state and RBAC rules
- Template publish requires template admin membership or super admin
- Condition approval and rollback should be limited to operators who manage condition lifecycle
- Action triggering may be visible only when the action definition is visible/enabled in the current context

Backend evidence used for these classifications:

- `app/services/rbac.py` defines admin privilege checks and access identity resolution
- `app/api/resources_projects.py` filters list access through project-read RBAC
- `app/api/resources_forms.py` uses workflow helpers and the current authenticated user
- `app/api/ui_templates.py` checks template admins or super admin before publishing
- `app/api/conditions.py` exposes condition lifecycle and analytics endpoints

## State Management Modules

Recommended state modules:

- `AuthState`
  - current auth status, access token, refresh token, user profile, session UUID
- `SessionState`
  - active sessions list, current session, revoke/logout mutations
- `CurrentUserState`
  - `GET /api/v1/auth/me` result plus privilege flags
- `ProjectState`
  - selected project, project list, project detail, project versions
- `FormState`
  - selected form, sections list, workflow state/history, effective UI config
- `SectionState`
  - selected section, section detail, section versions
- `QuestionState`
  - selected question, question detail, question versions
- `ChoiceState`
  - choices list and selected choice
- `ConditionState`
  - selected condition, metadata, test results, approvals, versions, presets, async jobs, monitoring snapshots
- `AdminState`
  - admin dashboard aggregates, audit logs, user sessions, config health, rate limits
- `SystemState`
  - health, readiness, metrics, schema echo status
- `PaginationState<T>`
  - offset/cursor/page metadata, request status, next cursor

Suggested approach:

- Keep auth/token state in a small durable store
- Keep resource data in repository-backed state objects with explicit loading/error/result fields
- Do not duplicate backend models in component-local state; normalize them in repositories and feature stores

## Shared Data Models

Derive shared client models from OpenAPI and supplement with thin hand-written wrappers where necessary.

Core shared models:

- `ApiError`
- `PaginationMeta`
- `PageResult<T>`
- `CursorPageResult<T>`
- `TokenPair`
- `AccessTokenResponse`
- `UserProfile`
- `SessionInfo`
- `Project`
- `ProjectVersion`
- `Form`
- `FormVersion`
- `FormWorkflowEvent`
- `Section`
- `SectionVersion`
- `Question`
- `QuestionVersion`
- `Choice`
- `ChoiceRef`
- `ActionDefinition`
- `ActionExecution`
- `Condition`
- `ConditionTestResult`
- `ConditionMetadata`
- `ConditionPreset`
- `Template`
- `TemplateRevision`
- `RateLimitRule`
- `AdminConfigHealth`
- `HealthStatus`
- `MetricsSnapshot`

Important backend validation-driven model rules to preserve:

- email normalization and minimum password length for register/login
- repeatable count bounds on forms, sections, and questions
- action questions require action metadata
- reviewer/approver cardinality constraints on forms
- version UUID references must match existing version maps
- condition type/operator/operand shapes vary by condition family

## API Client Modules

Recommended client layering:

- `ApiClient`
  - wraps base URL, headers, request IDs, serialization, and error mapping
- `AuthApi`
  - register, login, refresh, logout, me, sessions, revoke session, logout-all
- `ProjectsApi`
  - project CRUD and project versions
- `FormsApi`
  - form CRUD, versions, workflow, effective UI config
- `SectionsApi`
  - section CRUD and section versions
- `QuestionsApi`
  - question CRUD and question versions
- `ChoicesApi`
  - choice CRUD
- `ActionsApi`
  - trigger action, list executions
- `ConditionsApi`
  - metadata, test, batch test, presets, versions, approval, monitoring, async evaluation, cache metrics, usage, impact
- `UiTemplatesApi`
  - theme/layout template create and publish
- `AdminApi`
  - audit logs, config health, user sessions, rate limits
- `SystemApi`
  - health, readiness, metrics, schema echo

Client requirements:

- auto-attach `Authorization: Bearer <access token>`
- handle refresh token rotation on 401 where appropriate
- map backend error payloads consistently
- support both page-based and cursor-based pagination
- surface request identifiers if backend returns them

## Form and Validation Requirements

### Authentication

- register:
  - `name` required
  - `email` required and valid
  - `password` minimum length 8
  - optional `designation`, `phone`, `device_name`
- login:
  - `email` required and valid
  - `password` required

### Project / form hierarchy

- UUID fields are required on create payloads
- `status` is restricted to backend literals
- version objects require `uuid`, `major`, `minor`, `patch`, and `status`

### Form-specific

- `requires_reviewer` / `requires_approver` imply minimum role counts
- `reviewers` must satisfy reviewer constraints when review is required
- `approvers` must satisfy approver constraints when approval is required
- `ui_overrides` is a free-form object, but should be treated as structured JSON in the client

### Section-specific

- `min_repeatable_count` cannot exceed `max_repeatable_count`
- `version_uuid` query parameter is required for create-section linking in versioned forms

### Question-specific

- `min_repeatable_count` cannot exceed `max_repeatable_count`
- if `isAction` is true and no explicit action definitions exist, `actionType` and `actionLabel` are required
- choices are nested subdocuments and should validate before submit

### Choice-specific

- `label`, `value`, and `uuid` required for create
- `visibility_condition` is optional and references condition UUIDs

### Conditions

- validation must vary by `conditionType`
- asynchronous evaluation requires a condition UUID and context object
- batch endpoints accept arrays of condition test payloads
- approval and rollback inputs should be treated as workflow-specific and stateful

### UI templates

- create payloads accept base template metadata plus an optional initial revision
- publish requires template UUID and revision UUID

## Error, Loading, and Empty-State Handling

Implement these states consistently across all feature stores and pages:

- `loading`
  - initial fetch
  - refresh after mutation
  - pagination fetch
- `empty`
  - no projects, forms, sections, questions, choices, conditions, templates, sessions, logs, or rules
- `error`
  - 401 unauthorized
  - 403 forbidden
  - 404 missing resource
  - 409 workflow conflict or invalid state transition
  - 429 rate limited
  - validation errors from Pydantic/MongoEngine
  - backend validation failures from business rules

Recommended handling rules:

- 401 should route to login or token refresh flow
- 403 should preserve current page and show access denial for that scope
- 404 should fall back to the nearest parent page with a clear missing-resource state
- 409 should be surfaced for workflow transitions, idempotency conflicts, or action preconditions
- 429 should preserve form input and expose retry timing when present

## Feature-by-Feature Implementation Phases

### Phase 1: Foundation

- create Flutter shell, router, auth store, token storage, and API client
- generate or hand-map shared client models from OpenAPI
- implement login, register, me, refresh, logout, sessions
- implement system health/readiness/metrics pages

Dependency outcome:

- all later pages can rely on authenticated API wiring and durable session handling

### Phase 2: Core hierarchy browsing

- projects list/detail
- forms list/detail
- sections list/detail
- questions list/detail
- choices list/detail

Dependency outcome:

- users can traverse the resource tree before editing

### Phase 3: Core editing and versioning

- project edit/version pages
- form edit/version pages
- section edit/version pages
- question edit/version pages
- choice edit page

Dependency outcome:

- the client can manage the full hierarchy and preserve backend version semantics

### Phase 4: Workflow and effective configuration

- form submit/review/approve
- form workflow history if the backend exposes it through model responses
- effective UI config view
- action execution history and action triggering

Dependency outcome:

- operational workflows are available for users with permission to move forms through lifecycle states

### Phase 5: Conditions feature set

- condition metadata and operator metadata
- single and batch tests
- presets and preset import/export
- approval transition/rollback
- version history/restore
- monitoring dashboards
- async evaluation jobs
- cache metrics and invalidation
- impact and usage views

Dependency outcome:

- condition operators can be authored and verified from the client

### Phase 6: Template management

- theme templates create/publish
- layout templates create/publish
- template detail views and revision selection

Dependency outcome:

- form UI configuration can be managed end-to-end

### Phase 7: Admin and governance

- admin config health
- admin audit logs/search
- admin user sessions and revocation
- admin rate-limit configuration/logs/status

Dependency outcome:

- full operational admin coverage

## Risks, Unknowns, and Assumptions

- The backend exposes OpenAPI through `flask-openapi3`, but some endpoints use ad hoc request parsing; client generation may need hand-written wrappers for those routes.
- The public docs mention some legacy endpoints and compatibility redirects, but the Flutter app should target only `/api/v1` routes.
- Some endpoints are admin/ops oriented and may not need first-class navigation in the initial app shell.
- The backend does not yet expose obvious list/detail endpoints for every condition/template/admin entity beyond the routes above; some pages will need to be read-only or action-oriented rather than full CRUD.
- The action execution feature includes `frontend`-targeted steps, which suggests the Flutter client may eventually need a local action runner or deferred handler model.
- RBAC is enforced server-side; the client should not invent authorization rules, only reflect backend-derived access states.
- There is already a Flutter client in this repository, so new work should align with the existing app shell, provider wiring, and feature modules instead of assuming a greenfield structure.

## Deferred Items

These items have backend support but should be deferred until the core hierarchy/auth flows ship, or should remain backend-only until a clear UI need is confirmed:

- `GET /api/v1/auth/admin/audit-logs/search` advanced search UI
- some condition monitoring views if the volume or shape of data is not yet stable
- bulk condition import/export and bulk validation tools
- advanced rate-limit configuration editing if the app is primarily a form-management client
- schema echo validation if it is only used for diagnostics
- any backend-only compatibility redirects under `/api/...`
- internal operational dashboards that are useful for admins but not required for end users
