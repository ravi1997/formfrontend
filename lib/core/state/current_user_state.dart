import 'package:flutter/material.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

class CurrentUserState extends ChangeNotifier {
  UserProfile? _user;

  UserProfile? get user => _user;

  void updateUser(UserProfile? newUser) {
    _user = newUser;
    notifyListeners();
  }

  bool get isAdmin => _user?.roles.contains('admin') ?? false;
  bool get isSuperAdmin => _user?.roles.contains('super_admin') ?? false;
  bool get isOperator => _user?.roles.contains('operator') ?? false;

  bool hasRole(String role) => _user?.roles.contains(role) ?? false;
}
