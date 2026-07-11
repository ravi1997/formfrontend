import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/features/auth/data/auth_api.dart';
import 'package:formfrontend/features/auth/data/auth_repository_impl.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';
import 'package:formfrontend/features/responses/data/responses_api.dart';
import 'package:formfrontend/features/workflows/data/workflows_api.dart';
import 'package:formfrontend/features/system/data/system_api.dart';
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';
import 'package:formfrontend/core/state/auth_state.dart';
import 'package:formfrontend/core/state/session_state.dart';
import 'package:formfrontend/core/state/current_user_state.dart';
import 'package:formfrontend/features/auth/presentation/login_page.dart';
import 'package:formfrontend/app/router/app_router.dart';
import 'package:formfrontend/app/router/route_names.dart';
import 'package:formfrontend/app/shell/main_shell.dart';

class App extends StatelessWidget {
  final SecureTokenStorage? tokenStorage;

  const App({super.key, this.tokenStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Durable storage
        Provider<SecureTokenStorage>(
          create: (_) => tokenStorage ?? SecureTokenStorage(),
        ),
        // API layer
        ProxyProvider<SecureTokenStorage, ApiClient>(
          update: (context, storage, previous) => ApiClient(tokenStorage: storage),
        ),
        // Auth feature data layer
        ProxyProvider<ApiClient, AuthApi>(
          update: (context, client, previous) => AuthApi(client),
        ),
        // Auth repository implementation
        ProxyProvider2<AuthApi, SecureTokenStorage, AuthRepository>(
          update: (context, api, storage, previous) => AuthRepositoryImpl(api: api, storage: storage),
        ),
        ProxyProvider<ApiClient, ProjectsApi>(
          update: (context, client, previous) => ProjectsApi(client),
        ),
        ProxyProvider<ApiClient, FormsApi>(
          update: (context, client, previous) => FormsApi(client),
        ),
        ProxyProvider<ApiClient, SectionsApi>(
          update: (context, client, previous) => SectionsApi(client),
        ),
        ProxyProvider<ApiClient, QuestionsApi>(
          update: (context, client, previous) => QuestionsApi(client),
        ),
        ProxyProvider<ApiClient, ChoicesApi>(
          update: (context, client, previous) => ChoicesApi(client),
        ),
        ProxyProvider<ApiClient, ConditionsApi>(
          update: (context, client, previous) => ConditionsApi(client),
        ),
        ProxyProvider<ApiClient, AdminApi>(
          update: (context, client, previous) => AdminApi(client),
        ),
        ProxyProvider<ApiClient, WorkflowsApi>(
          update: (context, client, previous) => WorkflowsApi(client),
        ),
        ProxyProvider<ApiClient, ResponsesApi>(
          update: (context, client, previous) => ResponsesApi(client),
        ),
        ProxyProvider<ApiClient, SystemApi>(
          update: (context, client, previous) => SystemApi(client),
        ),
        ProxyProvider<ApiClient, UiTemplatesApi>(
          update: (context, client, previous) => UiTemplatesApi(client),
        ),
        // Auth State Notifier
        ChangeNotifierProvider<AuthStateNotifier>(
          create: (context) => AuthStateNotifier(
            authRepository: context.read<AuthRepository>(),
            tokenStorage: context.read<SecureTokenStorage>(),
          ),
        ),
        // Session State Notifier
        ChangeNotifierProvider<SessionStateNotifier>(
          create: (context) => SessionStateNotifier(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        // Current User Privileges State
        ChangeNotifierProxyProvider<AuthStateNotifier, CurrentUserState>(
          create: (_) => CurrentUserState(),
          update: (_, authState, currentUserState) {
            currentUserState?.updateUser(authState.currentUser);
            return currentUserState ?? CurrentUserState();
          },
        ),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            title: 'A.D.I.Y.O.G.I',
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
            initialRoute: RouteNames.main,
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: const AppAuthBarrier(),
          );
        },
      ),
    );
  }
}

class AppAuthBarrier extends StatelessWidget {
  const AppAuthBarrier({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthStateNotifier>();

    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.authenticating:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.charcoal),
            ),
          ),
        );
      case AuthStatus.authenticated:
        return const MainShell();
      case AuthStatus.unauthenticated:
        return const LoginPage();
    }
  }
}
