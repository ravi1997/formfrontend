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
      uuid: json['uuid'] as String? ?? json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      designation: json['designation'] as String?,
      phone: json['phone'] as String?,
      roles: parsedRoles,
      isSuperAdmin: json['is_super_admin'] as bool? ?? false,
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
      uuid: json['uuid'] as String? ?? json['id'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? 'Unknown Device',
      lastActiveAt: json['last_active_at'] as String? ?? '',
      isCurrent: json['is_current'] as bool? ?? false,
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
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      sessionUuid: json['session_uuid'] as String?,
      user: json['user'] != null
          ? UserProfile.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}
