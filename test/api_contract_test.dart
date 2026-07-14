import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formfrontend/app/router/app_router.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

void main() {
  test('ApiEndpoints build expected nested resource paths', () {
    expect(
      ApiEndpoints.choices('p1', 'f1', 's1', 'q1'),
      '/api/v1/projects/p1/forms/f1/sections/s1/questions/q1/choices',
    );
    expect(
      ApiEndpoints.sectionDetail('p1', 'f1', 's1'),
      '/api/v1/projects/p1/forms/f1/sections/s1',
    );
    expect(
      ApiEndpoints.questionVersions('p1', 'f1', 's1', 'q1'),
      '/api/v1/projects/p1/forms/f1/sections/s1/questions/q1/versions',
    );
    expect(
      ApiEndpoints.actionExecutions('p1', 'f1', 'r1'),
      '/api/v1/projects/p1/forms/f1/responses/r1/action-executions',
    );
    expect(
      ApiEndpoints.publicResponses('p1', 'f1'),
      '/api/v1/public/projects/p1/forms/f1/responses',
    );
    expect(
      ApiEndpoints.submitFormWorkflow('p1', 'f1'),
      '/api/v1/projects/p1/forms/f1/workflow/submit',
    );
    expect(ApiEndpoints.projects, '/api/v1/projects');
    expect(ApiEndpoints.search, '/search');
    expect(ApiEndpoints.projectDetail('p1'), '/api/v1/projects/p1');
    expect(ApiEndpoints.forms('p1'), '/api/v1/projects/p1/forms');
    expect(ApiEndpoints.projectDetail('p1'), '/api/v1/projects/p1');
    expect(ApiEndpoints.formDetail('p1', 'f1'), '/api/v1/projects/p1/forms/f1');
    expect(
      ApiEndpoints.formVersions('p1', 'f1'),
      '/api/v1/projects/p1/forms/f1/versions',
    );
    expect(
      ApiEndpoints.effectiveUi('p1', 'f1'),
      '/api/v1/projects/p1/forms/f1/ui/effective',
    );
    expect(
      ApiEndpoints.sectionVersions('p1', 'f1', 's1'),
      '/api/v1/projects/p1/forms/f1/sections/s1/versions',
    );
    expect(
      ApiEndpoints.sectionDetail('p1', 'f1', 's1'),
      '/api/v1/projects/p1/forms/f1/sections/s1',
    );
    expect(
      ApiEndpoints.questionDetail('p1', 'f1', 's1', 'q1'),
      '/api/v1/projects/p1/forms/f1/sections/s1/questions/q1',
    );
    expect(
      ApiEndpoints.questionVersions('p1', 'f1', 's1', 'q1'),
      '/api/v1/projects/p1/forms/f1/sections/s1/questions/q1/versions',
    );
    expect(
      ApiEndpoints.choiceDetail('p1', 'f1', 's1', 'q1', 'c1'),
      '/api/v1/projects/p1/forms/f1/sections/s1/questions/q1/choices/c1',
    );
    expect(
      ApiEndpoints.choices('p1', 'f1', 's1', 'q1'),
      '/api/v1/projects/p1/forms/f1/sections/s1/questions/q1/choices',
    );
    expect(ApiEndpoints.conditionsMetadata, '/conditions/metadata');
    expect(ApiEndpoints.presets, '/conditions/presets');
    expect(ApiEndpoints.testCondition, '/conditions/test');
    expect(ApiEndpoints.themeTemplates, '/ui/theme-templates');
    expect(
      ApiEndpoints.publishThemeTemplate('t1', 'r1'),
      '/ui/theme-templates/t1/revisions/r1/publish',
    );
    expect(ApiEndpoints.layoutTemplates, '/ui/layout-templates');
    expect(
      ApiEndpoints.publishLayoutTemplate('t2', 'r2'),
      '/ui/layout-templates/t2/revisions/r2/publish',
    );
    expect(ApiEndpoints.organizations, '/organizations');
    expect(ApiEndpoints.organizationDetail('o1'), '/organizations/o1');
  });

  test('Auth model parsing accepts common backend shapes', () {
    final auth = AuthResponse.fromJson({
      'access_token': 'access',
      'refresh_token': 'refresh',
      'session_uuid': 'session-1',
      'user': {
        'uuid': 'user-1',
        'email': 'user@example.com',
        'name': 'User',
        'roles': ['admin', 'operator'],
      },
    });

    expect(auth.accessToken, 'access');
    expect(auth.refreshToken, 'refresh');
    expect(auth.sessionUuid, 'session-1');
    expect(auth.user?.uuid, 'user-1');
    expect(auth.user?.roles, ['admin', 'operator']);
  });

  test('UserProfile parsing handles map-based role payloads', () {
    final profile = UserProfile.fromJson({
      'uuid': 'user-2',
      'email': 'ops@example.com',
      'name': 'Ops',
      'roles': {
        'primary': ['super_admin'],
        'secondary': 'operator',
      },
    });

    expect(profile.uuid, 'user-2');
    expect(profile.roles, containsAll(['super_admin', 'operator']));
  });

  test(
    'Auth model parsing tolerates stringified and numeric backend fields',
    () {
      final auth = AuthResponse.fromJson({
        'access_token': 123,
        'refresh_token': 'refresh',
        'session_uuid': 456,
        'user': {
          'id': 789,
          'email': 'ops@example.com',
          'name': 'Ops',
          'designation': 42,
          'phone': 5551234,
          'is_super_admin': 1,
        },
      });

      expect(auth.accessToken, '123');
      expect(auth.sessionUuid, '456');
      expect(auth.user?.uuid, '789');
      expect(auth.user?.designation, '42');
      expect(auth.user?.phone, '5551234');
      expect(auth.user?.isSuperAdmin, isTrue);
    },
  );

  test('AppRouter maps backend domain routes into the shell', () {
    final projectDetailRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.projectDetail, arguments: 'p1'),
    );
    final formDetailRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.formDetail,
        arguments: {'projectUuid': 'p1', 'formUuid': 'f1'},
      ),
    );
    final formVersionsRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.formVersions,
        arguments: {'projectUuid': 'p1', 'formUuid': 'f1'},
      ),
    );
    final formEffectiveUiRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.formEffectiveUi,
        arguments: {'projectUuid': 'p1', 'formUuid': 'f1'},
      ),
    );
    final sectionDetailRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.sectionDetail,
        arguments: {'projectUuid': 'p1', 'formUuid': 'f1', 'sectionUuid': 's1'},
      ),
    );
    final sectionVersionsRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.sectionVersions,
        arguments: {'projectUuid': 'p1', 'formUuid': 'f1', 'sectionUuid': 's1'},
      ),
    );
    final questionDetailRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.questionDetail,
        arguments: {
          'projectUuid': 'p1',
          'formUuid': 'f1',
          'sectionUuid': 's1',
          'questionUuid': 'q1',
        },
      ),
    );
    final questionVersionsRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.questionVersions,
        arguments: {
          'projectUuid': 'p1',
          'formUuid': 'f1',
          'sectionUuid': 's1',
          'questionUuid': 'q1',
        },
      ),
    );
    final choiceEditRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.choiceEdit,
        arguments: {
          'projectUuid': 'p1',
          'formUuid': 'f1',
          'sectionUuid': 's1',
          'questionUuid': 'q1',
          'choiceUuid': 'c1',
        },
      ),
    );
    final conditionsRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditions),
    );
    final conditionBatchRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditionBatchTest),
    );
    final conditionVersionsRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditionVersions),
    );
    final conditionApprovalRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditionApproval),
    );
    final conditionAsyncRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditionAsync),
    );
    final conditionPresetsRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditionPresets),
    );
    final conditionMonitoringRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditionMonitoring),
    );
    final monitoringRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.conditions, arguments: 'monitoring'),
    );
    final projectsRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.projects),
    );
    final searchRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.search),
    );
    final themesRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.themes),
    );
    final themeTemplateRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.themeTemplateDetail,
        arguments: {'templateUuid': 't1'},
      ),
    );
    final layoutTemplateRoute = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: RouteNames.layoutTemplateDetail,
        arguments: {'templateUuid': 'l1'},
      ),
    );
    final loginRoute = AppRouter.onGenerateRoute(
      const RouteSettings(name: RouteNames.login),
    );

    expect(projectDetailRoute.settings.name, RouteNames.projectDetail);
    expect(formDetailRoute.settings.name, RouteNames.formDetail);
    expect(formVersionsRoute.settings.name, RouteNames.formVersions);
    expect(formEffectiveUiRoute.settings.name, RouteNames.formEffectiveUi);
    expect(sectionDetailRoute.settings.name, RouteNames.sectionDetail);
    expect(sectionVersionsRoute.settings.name, RouteNames.sectionVersions);
    expect(questionDetailRoute.settings.name, RouteNames.questionDetail);
    expect(questionVersionsRoute.settings.name, RouteNames.questionVersions);
    expect(choiceEditRoute.settings.name, RouteNames.choiceEdit);
    expect(conditionsRoute.settings.name, RouteNames.conditions);
    expect(conditionBatchRoute.settings.name, RouteNames.conditionBatchTest);
    expect(conditionVersionsRoute.settings.name, RouteNames.conditionVersions);
    expect(conditionApprovalRoute.settings.name, RouteNames.conditionApproval);
    expect(conditionAsyncRoute.settings.name, RouteNames.conditionAsync);
    expect(conditionPresetsRoute.settings.name, RouteNames.conditionPresets);
    expect(
      conditionMonitoringRoute.settings.name,
      RouteNames.conditionMonitoring,
    );
    expect(monitoringRoute.settings.name, RouteNames.conditions);
    expect(projectsRoute.settings.name, RouteNames.projects);
    expect(searchRoute.settings.name, RouteNames.search);
    expect(themesRoute.settings.name, RouteNames.themes);
    expect(themeTemplateRoute.settings.name, RouteNames.themeTemplateDetail);
    expect(layoutTemplateRoute.settings.name, RouteNames.layoutTemplateDetail);
    expect(loginRoute.settings.name, RouteNames.login);
  });
}
