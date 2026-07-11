# formfrontend

Flutter frontend for the backend in `/home/ravi/workspace/new/form`.

## Local setup

1. Start the backend first.
2. Set `API_BASE_URL` in `assets/.env` to the backend API root, for example:

```env
API_BASE_URL=http://localhost:5000/api/v1
```

3. Run the app with Flutter:

```bash
flutter pub get
flutter run
```

## Routes

The app shell exposes backend-domain tabs and named routes for:

- `/`
- `/dashboard`
- `/projects`
- `/forms`
- `/sections`
- `/questions`
- `/choices`
- `/responses/submit`
- `/responses/actions`
- `/workflow`
- `/health`
- `/readiness`
- `/metrics`
- `/schema`
- `/ui/themes`
- `/ui/layouts`
- `/admin`
- `/admin/config-health`
- `/admin/audit-logs`
- `/admin/rate-limits`
- `/admin/user-sessions`

## Tests

```bash
flutter test
```

## Notes

- The app reads runtime config from `assets/.env`.
- API requests are routed through `lib/core/api/api_client.dart`.
- Auth/session state is bootstrapped from secure token storage.
