// ignore_for_file: prefer_initializing_formals
import 'package:flutter/material.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

class SessionStateNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;

  List<SessionInfo> _sessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  SessionStateNotifier({required AuthRepository authRepository})
      : _authRepository = authRepository;

  List<SessionInfo> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.getSessions();
    result.when(
      success: (sessionsList) {
        _sessions = sessionsList;
        _errorMessage = null;
      },
      failure: (error) {
        _errorMessage = error.message;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> revokeSession(String sessionUuid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.revokeSession(sessionUuid);
    bool success = false;
    await result.when(
      success: (_) async {
        success = true;
        await fetchSessions(); // Refresh list after revoke
      },
      failure: (error) {
        _errorMessage = error.message;
      },
    );
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> revokeAllSessions({bool keepCurrent = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.logoutAll(keepCurrent: keepCurrent);
    bool success = false;
    await result.when(
      success: (_) async {
        success = true;
        if (keepCurrent) {
          await fetchSessions(); // Refresh remaining sessions
        } else {
          _sessions = [];
        }
      },
      failure: (error) {
        _errorMessage = error.message;
      },
    );
    _isLoading = false;
    notifyListeners();
    return success;
  }
}
