/// Lightweight representation of a user coming from the backend.
class UserProfile {
  const UserProfile({
    required this.userId,
    required this.username,
    required this.email,
    this.id,
    this.isGuest = false,
    this.level = 1,
    this.xp = 0,
    this.diamond = 0,
    this.hints = 0,
    this.locale = 'tr',
    this.country = 'TR',
    this.status = 'active',
    this.avatarPath,
    this.createdAt,
    this.lastLoginAt,
  });

  final int? id;
  final String userId;
  final String username;
  final String email;
  final bool isGuest;
  final int level;
  final int xp;
  final int diamond;
  final int hints;
  final String locale;
  final String country;
  final String status;
  final String? avatarPath;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserProfile copyWith({
    int? id,
    String? userId,
    String? username,
    String? email,
    bool? isGuest,
    int? level,
    int? xp,
    int? diamond,
    int? hints,
    String? locale,
    String? country,
    String? status,
    String? avatarPath,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      diamond: diamond ?? this.diamond,
      hints: hints ?? this.hints,
      locale: locale ?? this.locale,
      country: country ?? this.country,
      status: status ?? this.status,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.tryParse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return UserProfile(
      id: json['id'] as int?,
      userId: (json['user_id'] ?? json['userId'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      isGuest: (json['is_guest'] ?? json['isGuest'] ?? 0) == 1 ||
          (json['is_guest'] ?? json['isGuest'] ?? false) == true,
      level: (json['level'] as int?) ?? 1,
      xp: (json['xp'] as int?) ?? 0,
      diamond: (json['diamond'] as int?) ?? 0,
      hints: (json['hints'] as int?) ?? 0,
      locale: (json['locale'] ?? 'tr') as String,
      country: (json['country'] ?? 'TR') as String,
      status: (json['status'] ?? 'active') as String,
      avatarPath: json['avatar_path'] as String? ?? json['avatarPath'] as String?,
      createdAt: parseDate(json['created_at'] ?? json['createdAt']),
      lastLoginAt: parseDate(json['last_login_at'] ?? json['lastLoginAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'username': username,
      'email': email,
      'is_guest': isGuest ? 1 : 0,
      'level': level,
      'xp': xp,
      'diamond': diamond,
      'hints': hints,
      'locale': locale,
      'country': country,
      'status': status,
      'avatar_path': avatarPath,
      'created_at': createdAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}
