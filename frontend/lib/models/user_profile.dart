class UserProfile {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.locale,
    this.country,
  });

  final String userId;
  final String name;
  final String email;
  final String? locale;
  final String? country;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id']?.toString() ?? '',
      name: json['username']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      locale: json['locale']?.toString(),
      country: json['country']?.toString(),
    );
  }

  Map<String, dynamic> toStorage() {
    return <String, dynamic>{
      'user_id': userId,
      'name': name,
      'email': email,
      'locale': locale,
      'country': country,
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
    );
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? locale,
    String? country,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      locale: locale ?? this.locale,
      country: country ?? this.country,
    );
  }
}
