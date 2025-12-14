class UserProfile {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.locale,
    this.country,
    this.level = 1,
    this.xp = 0,
    this.xpDd = 0,
    this.diamond = 0,
    this.hints = 0,
    this.status,
    this.avatarPath,
  });

  final String userId;
  final String name;
  final String email;
  final String? locale;
  final String? country;
  final int level;
  final int xp;
  final int xpDd;
  final int diamond;
  final int hints;
  final String? status;
  final String? avatarPath;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id']?.toString() ?? '',
      name: json['username']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      locale: json['locale']?.toString(),
      country: json['country']?.toString(),
      level: _parseInt(json['level'], fallback: 1),
      xp: _parseInt(json['xp']),
      xpDd: _parseInt(json['xp_dd']),
      diamond: _parseInt(json['diamond']),
      hints: _parseInt(json['hints'], fallback: 3),
      status: json['status']?.toString(),
      avatarPath: json['avatar_path']?.toString(),
    );
  }

  Map<String, dynamic> toStorage() {
    return <String, dynamic>{
      'user_id': userId,
      'name': name,
      'email': email,
      'locale': locale,
      'country': country,
      'level': level,
      'xp': xp,
      'xp_dd': xpDd,
      'diamond': diamond,
      'hints': hints,
      'status': status,
      'avatar_path': avatarPath,
    };
  }

  static UserProfile? fromStorage(Map<String, Object?>? data) {
    if (data == null) return null;
    final String? userId = data['user_id'] as String?;
    final String? name = data['name'] as String?;
    final String? email = data['email'] as String?;
    if (userId == null || name == null || email == null) return null;
    return UserProfile(
      userId: userId,
      name: name,
      email: email,
      locale: data['locale'] as String?,
      country: data['country'] as String?,
      level: _parseInt(data['level'], fallback: 1),
      xp: _parseInt(data['xp']),
      xpDd: _parseInt(data['xp_dd']),
      diamond: _parseInt(data['diamond']),
      hints: _parseInt(data['hints'], fallback: 3),
      status: data['status'] as String?,
      avatarPath: data['avatar_path'] as String?,
    );
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? locale,
    String? country,
    int? level,
    int? xp,
    int? xpDd,
    int? diamond,
    int? hints,
    String? status,
    String? avatarPath,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      locale: locale ?? this.locale,
      country: country ?? this.country,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpDd: xpDd ?? this.xpDd,
      diamond: diamond ?? this.diamond,
      hints: hints ?? this.hints,
      status: status ?? this.status,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  static int _parseInt(Object? value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? fallback;
  }
}
