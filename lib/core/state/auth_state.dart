// ignore_for_file: prefer_initializing_formals
import 'package:flutter/material.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthStateNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SecureTokenStorage _tokenStorage;

  AuthStatus _status = AuthStatus.initial;
  UserProfile? _currentUser;
  String? _errorMessage;

  AuthStateNotifier({
    required AuthRepository authRepository,
    required SecureTokenStorage tokenStorage,
  })  : _authRepository = authRepository,
        _tokenStorage = tokenStorage {
    checkAuthStatus();
  }

  AuthStatus get status => _status;
  UserProfile? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> checkAuthStatus() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    _status = AuthStatus.authenticating;
    notifyListeners();

    final result = await _authRepository.getMe();
    var shouldClearCredentials = false;
    result.when(
      success: (user) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
        _errorMessage = null;
      },
      failure: (error) {
        shouldClearCredentials = error.statusCode == 401 || error.statusCode == 403;
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
        _errorMessage = error.message;
      },
    );
    if (shouldClearCredentials) {
      await _tokenStorage.clearAll();
    }
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.login(email: email, password: password);
    bool success = false;
    await result.when(
      success: (authResp) async {
        _currentUser = authResp.user;
        _status = AuthStatus.authenticated;
        success = true;
        // In case User profile was not returned in the login payload, fetch it
        if (_currentUser == null) {
          final meResult = await _authRepository.getMe();
          meResult.when(
            success: (user) {
              _currentUser = user;
            },
            failure: (error) {
              _errorMessage = error.message;
            },
          );
        }
      },
      failure: (error) {
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
        _errorMessage = error.message;
      },
    );
    notifyListeners();
    return success;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? designation,
    String? phone,
    String? deviceName,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
      designation: designation,
      phone: phone,
      deviceName: deviceName,
    );
    bool success = false;
    await result.when(
      success: (authResp) async {
        success = true;
        final hasTokens = authResp.accessToken.isNotEmpty && authResp.refreshToken.isNotEmpty;
        if (hasTokens) {
          _currentUser = authResp.user;
          _status = AuthStatus.authenticated;
          if (_currentUser == null) {
            final meResult = await _authRepository.getMe();
            meResult.when(
              success: (user) => _currentUser = user,
              failure: (error) => _errorMessage = error.message,
            );
          }
        } else {
          _currentUser = authResp.user;
          _status = AuthStatus.unauthenticated;
          _errorMessage = null;
        }
      },
      failure: (error) {
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
        _errorMessage = error.message;
      },
    );
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    await _authRepository.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }
}
