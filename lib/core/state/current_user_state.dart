import 'package:flutter/material.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

class CurrentUserState extends ChangeNotifier {
  UserProfile? _user;

  UserProfile? get user => _user;

  void updateUser(UserProfile? newUser) {
    _user = newUser;
    notifyListeners();
  }

  bool _checkRole(String target) {
    if (_user == null) return false;
    final normalizedTarget = target.toLowerCase().replaceAll('role_', '').replaceAll('-', '_');
    return _user!.roles.any((r) {
      final normalizedRole = r.toLowerCase().replaceAll('role_', '').replaceAll('-', '_');
      return normalizedRole == normalizedTarget || 
             (normalizedTarget == 'super_admin' && normalizedRole == 'superadmin') ||
             (normalizedTarget == 'superadmin' && normalizedRole == 'super_admin');
    });
  }

  bool get isAdmin => _checkRole('admin');
  bool get isSuperAdmin {
    if (_user == null) return false;
    return _user!.isSuperAdmin || _checkRole('super_admin');
  }
  bool get isOperator => _checkRole('operator');

  bool hasRole(String role) => _checkRole(role);
}
