import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:formfrontend/core/config/theme/theme_exports.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/features/auth/data/auth_api.dart';
import 'package:formfrontend/features/auth/data/auth_repository_impl.dart';
import 'package:formfrontend/core/state/auth_state.dart';
import 'package:formfrontend/core/state/session_state.dart';
import 'package:formfrontend/core/state/current_user_state.dart';
import 'package:formfrontend/features/auth/presentation/login_page.dart';
import 'package:formfrontend/features/dashboard/presentation/dashboard_screen.dart';

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
        return const DashboardScreen();
      case AuthStatus.unauthenticated:
        return const LoginPage();
    }
  }
}
