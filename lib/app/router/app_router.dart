import 'package:flutter/material.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/app/shell/main_shell.dart';
import 'package:formfrontend/features/auth/presentation/login_page.dart';
import 'package:formfrontend/features/auth/presentation/register_page.dart';
import 'package:formfrontend/features/forms/presentation/form_detail_page.dart';
import 'package:formfrontend/features/forms/presentation/form_effective_ui_page.dart';
import 'package:formfrontend/features/forms/presentation/form_versions_page.dart';
import 'package:formfrontend/features/projects/presentation/project_detail_page.dart';
import 'package:formfrontend/features/conditions/presentation/condition_test_page.dart';
import 'package:formfrontend/features/choices/presentation/choice_edit_page.dart';
import 'package:formfrontend/features/questions/presentation/question_detail_page.dart';
import 'package:formfrontend/features/questions/presentation/question_versions_page.dart';
import 'package:formfrontend/features/sections/presentation/section_detail_page.dart';
import 'package:formfrontend/features/sections/presentation/section_versions_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final mainIndex = _mainIndexFor(settings.name);

    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage(), settings: settings);
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage(), settings: settings);
      case RouteNames.projectDetail:
        final projectUuid = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ProjectDetailPage(projectUuid: projectUuid),
          settings: settings,
        );
      case RouteNames.choiceEdit:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => ChoiceEditPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
            sectionUuid: args['sectionUuid'] ?? '',
            questionUuid: args['questionUuid'] ?? '',
            choiceUuid: args['choiceUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.conditions:
        return MaterialPageRoute(builder: (_) => const ConditionTestPage(), settings: settings);
      case RouteNames.formDetail:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => FormDetailPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.formVersions:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => FormVersionsPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.formEffectiveUi:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => FormEffectiveUiPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.sectionDetail:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => SectionDetailPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
            sectionUuid: args['sectionUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.sectionVersions:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => SectionVersionsPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
            sectionUuid: args['sectionUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.questionDetail:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => QuestionDetailPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
            sectionUuid: args['sectionUuid'] ?? '',
            questionUuid: args['questionUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.questionVersions:
        final args = settings.arguments as Map<String, String>? ?? const {};
        return MaterialPageRoute(
          builder: (_) => QuestionVersionsPage(
            projectUuid: args['projectUuid'] ?? '',
            formUuid: args['formUuid'] ?? '',
            sectionUuid: args['sectionUuid'] ?? '',
            questionUuid: args['questionUuid'] ?? '',
          ),
          settings: settings,
        );
      case RouteNames.main:
      case RouteNames.dashboard:
      case RouteNames.projects:
      case RouteNames.forms:
      case RouteNames.sections:
      case RouteNames.questions:
      case RouteNames.choices:
      case RouteNames.submit:
      case RouteNames.actions:
      case RouteNames.workflow:
      case RouteNames.health:
      case RouteNames.readiness:
      case RouteNames.metrics:
      case RouteNames.schema:
      case RouteNames.themes:
      case RouteNames.layouts:
      case RouteNames.admin:
      case RouteNames.adminConfigHealth:
      case RouteNames.adminAuditLogs:
      case RouteNames.adminRateLimits:
      case RouteNames.adminUserSessions:
        return MaterialPageRoute(
          builder: (_) => MainShell(initialIndex: mainIndex),
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (_) => const MainShell(), settings: settings);
    }
  }

  static int _mainIndexFor(String? routeName) {
    switch (routeName) {
      case RouteNames.dashboard:
      case RouteNames.main:
        return 0;
      case RouteNames.projects:
        return 1;
      case RouteNames.forms:
        return 2;
      case RouteNames.sections:
        return 3;
      case RouteNames.questions:
        return 4;
      case RouteNames.choices:
        return 5;
      case RouteNames.conditions:
        return 6;
      case RouteNames.submit:
        return 7;
      case RouteNames.actions:
        return 8;
      case RouteNames.workflow:
        return 9;
      case RouteNames.health:
        return 10;
      case RouteNames.readiness:
        return 11;
      case RouteNames.metrics:
        return 12;
      case RouteNames.schema:
        return 13;
      case RouteNames.themes:
        return 14;
      case RouteNames.layouts:
        return 15;
      case RouteNames.admin:
        return 16;
      case RouteNames.adminConfigHealth:
        return 17;
      case RouteNames.adminAuditLogs:
        return 18;
      case RouteNames.adminRateLimits:
        return 19;
      case RouteNames.adminUserSessions:
        return 20;
      default:
        return 0;
    }
  }
}
