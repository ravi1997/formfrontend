class UserProfile {
  final String uuid;
  final String email;
  final String name;
  final String? designation;
  final String? phone;
  final List<String> roles;
  final bool isSuperAdmin;

  const UserProfile({
    required this.uuid,
    required this.email,
    required this.name,
    this.designation,
    this.phone,
    required this.roles,
    this.isSuperAdmin = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final rolesRaw = json['roles'];
    final List<String> parsedRoles = [];
    if (rolesRaw is List) {
      parsedRoles.addAll(rolesRaw.map((e) => e.toString()));
    } else if (rolesRaw is Map) {
      rolesRaw.forEach((key, val) {
        if (val is List) {
          parsedRoles.addAll(val.map((e) => e.toString()));
        } else if (val != null) {
          parsedRoles.add(val.toString());
        }
      });
    }

    return UserProfile(
      uuid: _stringValue(json['uuid']) ?? _stringValue(json['id']) ?? '',
      email: _stringValue(json['email']) ?? '',
      name: _stringValue(json['name']) ?? '',
      designation: _stringValue(json['designation']),
      phone: _stringValue(json['phone']),
      roles: parsedRoles,
      isSuperAdmin: _boolValue(json['is_super_admin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'name': name,
      if (designation != null) 'designation': designation,
      if (phone != null) 'phone': phone,
      'roles': roles,
      'is_super_admin': isSuperAdmin,
    };
  }
}

class SessionInfo {
  final String uuid;
  final String deviceName;
  final String lastActiveAt;
  final bool isCurrent;

  const SessionInfo({
    required this.uuid,
    required this.deviceName,
    required this.lastActiveAt,
    required this.isCurrent,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      uuid: _stringValue(json['uuid']) ?? _stringValue(json['id']) ?? '',
      deviceName: _stringValue(json['device_name']) ?? 'Unknown Device',
      lastActiveAt: _stringValue(json['last_active_at']) ?? '',
      isCurrent: _boolValue(json['is_current']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'device_name': deviceName,
      'last_active_at': lastActiveAt,
      'is_current': isCurrent,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String? sessionUuid;
  final UserProfile? user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.sessionUuid,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: _stringValue(json['access_token']) ?? '',
      refreshToken: _stringValue(json['refresh_token']) ?? '',
      sessionUuid: _stringValue(json['session_uuid']),
      user: json['user'] != null
          ? UserProfile.fromJson(Map<String, dynamic>.from(json['user'] as Map))
          : null,
    );
  }
}

String? _stringValue(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

bool _boolValue(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().trim().toLowerCase();
  if (text == null || text.isEmpty) return false;
  return text == 'true' || text == '1' || text == 'yes';
}
