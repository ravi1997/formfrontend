# Plan 001: Make this Flutter repo the frontend of `/home/ravi/workspace/new/form`

> Executor instructions: use this as the implementation roadmap for the current repo state. Keep the plan synchronized with code and docs as work lands. If a step becomes stale, update the step before continuing.

## Status

- Priority: P1
- Effort: L
- Risk: MED
- Depends on: none
- Category: direction and execution
- Planned at: 2026-07-13

## Goal

Turn the existing Flutter app into the primary frontend for the backend in `/home/ravi/workspace/new/form`.

That means:

- every backend domain should have a clear frontend surface
- route structure should mirror backend hierarchy
- shared API and auth code should absorb backend response shape drift cleanly
- screens should be operational, not diagnostic dumps
- docs should describe the shipped app, not an aspirational one

## Current state

This repo already has substantial coverage:

- app bootstrap, shell, router, and route names exist
- shared API client, parsers, token storage, and auth/session state exist
- the core CRUD hierarchy is present for projects, forms, sections, questions, and choices
- workflows, responses, conditions, admin, system, and UI templates all have dedicated feature slices
- several screens and tests were already upgraded to show structured summaries instead of raw payloads

The remaining work is mainly:

- finish contract hardening
- close any screens that still lean too heavily on raw payload echoing
- keep route and shell navigation aligned with backend domains
- keep the parity matrix and plan docs current

## Source of truth

- Backend repo: `/home/ravi/workspace/new/form`
- Frontend repo: `/home/ravi/workspace/new/formfrontend`
- Product identity: `A.D.I.Y.O.G.I`
- Design system: `design.md`
- Voice and positioning: `brand.md`

## Working rules

- Keep backend-specific pages in `lib/features/<domain>/presentation/`
- Use the shared API client and `ApiResult<T>` patterns
- Keep route constants in `lib/app/router/route_names.dart`
- Keep routing in `lib/app/router/app_router.dart`
- Preserve the monochrome design system already documented
- Prefer small, verifiable patches over broad refactors
- Keep docs in sync with code

## Planning assumptions

- The backend is the product source of truth.
- The frontend should expose the backend lifecycle as a coherent navigation model.
- Any screen that does not improve operator understanding should be simplified or relegated to raw debug payloads.
- If a backend response shape is ambiguous, the client should parse it conservatively and fail visibly.

## Workstreams

### 1. Contract and state layer

Objective:

- make shared parsing and auth/session handling resilient to real backend payload shapes

Scope:

- `lib/core/api/api_client.dart`
- `lib/core/api/api_endpoints.dart`
- `lib/core/api/api_interceptors.dart`
- `lib/core/api/api_response_parsers.dart`
- `lib/core/auth/*`
- `lib/core/state/*`
- `lib/core/models/*`
- `test/api_contract_test.dart`
- `test/api_response_parsers_test.dart`
- `test/api_interceptors_test.dart`
- `test/auth_state_test.dart`

What to verify:

- list parsing accepts `items`, `data`, `results`, and raw lists
- auth/session parsing tolerates stringified and numeric values
- unauthorized responses clear stored credentials
- backend drift fails loudly enough to notice, but not so loudly that the app becomes unusable

### 2. Shell and routing

Objective:

- make navigation reflect backend domains and avoid dead routes

Scope:

- `lib/app/router/app_router.dart`
- `lib/app/router/route_names.dart`
- `lib/app/shell/main_shell.dart`
- `test/widget_test.dart`

What to verify:

- shell tabs map to the major backend lifecycle areas
- nested routes match backend hierarchy
- theme template routes remain split between theme and layout variants
- unsupported routes do not linger as hidden dead ends

### 3. Core resource surfaces

Objective:

- keep the hierarchy pages readable and backend-native

Scope:

- `lib/features/projects/presentation/*`
- `lib/features/forms/presentation/*`
- `lib/features/sections/presentation/*`
- `lib/features/questions/presentation/*`
- `lib/features/choices/presentation/*`
- `test/detail_pages_test.dart`
- feature-specific widget tests where needed

What to verify:

- project, form, section, and question detail pages show structured summary cards before raw payload blocks
- create/edit/version pages keep their backend field mapping explicit
- choice editing preserves nested payload behavior
- effective UI rendering stays aligned with backend renderer shapes

### 4. Workflow and response surfaces

Objective:

- make lifecycle actions visible and understandable

Scope:

- `lib/features/workflows/presentation/*`
- `lib/features/responses/presentation/*`
- related tests

What to verify:

- response submission shows request/result state
- action execution history is readable without raw JSON first
- workflow transitions remain tied to backend permissions and resource ownership

### 5. Conditions surfaces

Objective:

- turn condition pages into operational tools instead of diagnostic echoes

Scope:

- `lib/features/conditions/presentation/*`
- `test/condition_*.dart`

What to verify:

- single test, batch test, async evaluate, presets, approval, versions, and monitoring all expose a useful hierarchy
- monitoring pages keep labeled sections for graph, heatmap, unused, most-used, and evaluation stats
- approval and version pages show intent and lifecycle state clearly

### 6. Admin and ops surfaces

Objective:

- keep admin workflows structured enough to use without reading payloads first

Scope:

- `lib/features/admin/presentation/*`
- `test/admin_*.dart`
- `test/organisation_management_page_test.dart`

What to verify:

- dashboard aggregates the main operational signals
- audit logs, config health, user sessions, and rate limits all show summaries before payload dumps
- admin-only access stays enforced through route guards and auth state

### 7. System and UI template surfaces

Objective:

- keep product operations and presentation tooling legible

Scope:

- `lib/features/system/presentation/*`
- `lib/features/ui_templates/presentation/*`
- `test/system_pages_test.dart`
- `test/template_detail_page_test.dart`
- `test/template_lists_and_config_health_test.dart`

What to verify:

- health/readiness/metrics/schema echo pages stay aligned with live endpoints
- theme and layout templates show revision and publish state clearly
- template detail pages remain split by template family

### 8. Documentation parity

Objective:

- make the repo docs reflect the shipped frontend, not an older snapshot

Scope:

- `backend-frontend-parity.md`
- `plan.md`
- `plans/README.md`

What to verify:

- rows marked `partial` are reclassified when the feature is actually aligned
- any remaining gaps are labeled conservatively
- the plan summary matches the current implementation state

## Recommended execution order

1. Contract and state layer
2. Shell and routing
3. Core resource surfaces
4. Workflow and response surfaces
5. Conditions surfaces
6. Admin and ops surfaces
7. System and UI template surfaces
8. Documentation parity

## Validation strategy

Use the smallest meaningful verification set per workstream.

Recommended gates:

- `flutter analyze` after each logical patch batch
- focused widget tests for any touched page
- contract tests whenever API parsing or auth state changes
- `flutter test test/widget_test.dart` after routing or shell changes

If a change affects a live screen, add or update the corresponding widget test in the same pass.

## Done criteria

This plan is complete when all of the following are true:

- `flutter analyze` exits 0
- the targeted feature tests for changed surfaces exit 0
- the routing shell exposes backend-backed domains only
- the frontend treats backend payloads as structured operational data, not raw dumps
- parity docs reflect the actual code
- the plan file and README describe the shipped app accurately

## STOP conditions

Stop and re-check before proceeding if:

- a backend field the UI depends on is absent and there is no safe fallback
- a route requires a backend contract change to become correct
- a response shape cannot be handled locally without redesigning the shared API layer
- docs and code diverge enough that the current plan is no longer trustworthy

## Maintenance notes

- Keep the parity matrix conservative.
- Prefer the backend hierarchy when naming routes, pages, and tests.
- Treat raw payload blocks as debug aid, not the primary UX.
- If new backend routes appear, update router, shell, and docs together.
