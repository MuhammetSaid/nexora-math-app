import 'user_profile.dart';

/// Holds the authenticated user and tokens returned from the backend.
class AuthSession {
  const AuthSession({
    required this.user,
    this.token,
    this.refreshToken,
    this.issuedAt,
  });

  final String? token;
  final String? refreshToken;
  final DateTime? issuedAt;
  final UserProfile user;

  bool get isGuest => user.isGuest;

  AuthSession copyWith({
    UserProfile? user,
    String? token,
    String? refreshToken,
    DateTime? issuedAt,
  }) {
    return AuthSession(
      user: user ?? this.user,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.tryParse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return AuthSession(
      token: json['access_token'] as String? ?? json['token'] as String?,
      refreshToken: json['refresh_token'] as String? ?? json['refreshToken'] as String?,
      issuedAt: parseDate(json['issued_at'] ?? json['issuedAt']),
      user: UserProfile.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'refresh_token': refreshToken,
      'issued_at': issuedAt?.toIso8601String(),
      'user': user.toJson(),
    };
  }
}
