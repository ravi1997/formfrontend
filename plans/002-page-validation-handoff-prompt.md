# Page Validation Repair Prompt

You are an execution agent working in `/home/ravi/workspace/new/formfrontend`.

## Mission

- Fix every issue reported in the page validation report at `/home/ravi/.gemini/antigravity-cli/brain/5b55ceaf-b1ae-49bf-9754-8107ac7115e8/page_validation_report.md`.
- Also fix the current repository findings already discovered in this workspace.
- Do not miss any issue, regression, or page state.
- Preserve all existing successful fixes already present in the worktree.
- Finish with a verified, page-by-page result and no unresolved report items left unexplained.

## Non-negotiable rules

- Do not run or restart the app.
- The Flutter app is already running on port `9600`.
- Use the `agent-browser-advanced` skill for browser verification.
- Before fixing anything, build a complete inventory of every page, route, screen, and screen-state from the repository and compare it against the report.
- Test every discovered page individually.
- If a page has multiple routes, variants, tabs, parameters, or states, test each one separately.
- If a page requires authentication, authenticate using a valid verified account and record exactly which account and credentials source were used.
- If a page requires route parameters or sample data, use realistic values and record them exactly.
- If a page cannot be reached, explain exactly why.
- If a page is broken, record the exact failure, observed behavior, and likely cause.
- Do not collapse multiple pages into one entry.
- Do not say “similar pages passed.”
- Do not stop after a few representative tests.

## What to compare and fix

1. Compare the report against current code and current behavior.
2. Classify every issue into:
   - already fixed
   - still broken
   - partially fixed
   - needs verification
3. Treat the report as evidence, not truth. Re-verify against current code and runtime behavior.
4. Focus especially on:
   - pages marked `PARTIAL`
   - console exceptions on list/detail/system/admin pages
   - auth/session flow
   - backend-driven empty states
   - mock UUID 404/405 flows
   - admin/system summary pages
   - condition/workflow/response pages
   - metrics/readiness/schema pages

## Known issue families to address

- JSON parsing / payload-shape drift
  - Normalize backend responses that may arrive as map, list, nested object, null, or empty.
  - Never assume a list when the backend returns an object.
  - Never assume fields exist without guardrails.
- Empty-state rendering
  - Render empty and loading states cleanly without console exceptions.
  - Ensure “no data” states do not crash or emit invalid assumptions.
- Auth/session flow
  - Ensure registration, login, token storage, current-user lookup, and session listing are mutually consistent.
  - If register does not return tokens, do not mark the app authenticated.
  - If login requires verified accounts, make the frontend and verification flow explicit and testable.
- 404/405 detail routes
  - Detail/version/edit pages using mock UUIDs must show graceful error UI, not noisy crashes.
- Admin/system pages
  - Summary cards, counts, health, readiness, metrics, schema echo, audit, rate-limit, organisation, and session pages must render even when data is partial or missing.
- Browser stability
  - Any page that causes console exceptions or hangs must be fixed or explained with a precise root cause.

## Execution steps

1. Read the report in full.
2. Inspect the repository and create the full inventory of pages/routes/states.
3. Map the report’s 42 routes against the actual codebase.
4. Reproduce each failing or partial page in the browser.
5. Fix the root cause in code with the smallest possible change.
6. Add or update tests for every fix.
7. Re-run targeted Flutter analysis and tests.
8. Re-verify each page in the browser.
9. Confirm every page individually.

## Implementation expectations

- Use the repository source of truth, not assumptions.
- Prefer narrow, evidence-backed fixes.
- Reuse and preserve the existing fixes already in the worktree.
- If a page is marked partial because of a console exception, identify the exact exception and the code path causing it.
- If a page depends on backend data shape, harden the frontend against all observed shapes.
- If a backend endpoint contract is inconsistent with frontend expectations, fix the frontend contract handling first unless the backend mismatch is clearly the actual source of truth for the page behavior in this repo.
- If an authenticated route is blocked by seeded-account availability, explicitly add a reliable test account flow or document the exact backend prerequisite and verify with a real account.

## Required outputs

1. A full page inventory.
2. A comparison matrix:
   - report status
   - current status
   - delta
   - fix needed
3. One section per page with:
   - Page name
   - Route
   - Status: PASS / FAIL / PARTIAL
   - What was tested
   - Observed result
   - Errors
   - Missing coverage or follow-up needed
4. A short final section listing:
   - issues fixed
   - issues still open
   - issues that could not be reproduced
   - any backend prerequisite that blocked verification

## Verification

- Run targeted `flutter analyze` on changed files.
- Run focused `flutter test` for the affected flows.
- Use browser validation to confirm each page after fixes.
- Do not declare success until every discovered page has been tested and reported individually.

## Safety and precision

- Do not delete unrelated user changes.
- Do not do speculative refactors.
- Do not widen scope beyond the reported and discovered page issues.
- If you discover new pages during testing, add them to the inventory and test them too.
- If a route is wired incorrectly or not reachable, report it separately.

## Background context

The earlier comparison already identified and corrected or narrowed several issues:

- `Admin User Sessions` JSON parsing was fixed.
- Several admin/system pages were hardened against payload-shape drift and empty-state failures.
- `Register` no longer assumes signup returns tokens.

The report still contains many `PARTIAL` pages and console-exception cases that must be re-verified and either fixed or explained with evidence.
