import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../models/user/auth_session.dart';
import '../../models/user/user_profile.dart';

/// Contract for talking to the backend auth endpoints.
abstract class AuthService {
  Future<AuthSession> signInAsGuest();

  Future<AuthSession> signInWithGoogle({required String idToken});
}

/// API-backed implementation for production use.
class ApiAuthService implements AuthService {
  ApiAuthService({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  @override
  Future<AuthSession> signInAsGuest() {
    // No dedicated guest endpoint yet; fall back to local mock for now.
    return const MockAuthService().signInAsGuest();
  }

  @override
  Future<AuthSession> signInWithGoogle({required String idToken}) async {
    final Uri uri = Uri.parse('$baseUrl/auth/google');
    final http.Response response = await _client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{'idToken': idToken}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      return AuthSession.fromJson(body);
    }
    throw Exception(
      'Google sign-in failed (${response.statusCode}): ${response.body}',
    );
  }
}

/// Temporary mock service until FastAPI endpoints are connected.
class MockAuthService implements AuthService {
  const MockAuthService();

  @override
  Future<AuthSession> signInAsGuest() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final String userId = _randomId(prefix: 'guest');
    final UserProfile profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      username: 'Guest',
      email: '$userId@nexora.dev',
      isGuest: true,
      level: 1,
      xp: 0,
      diamond: 0,
      hints: 3,
    );
    return AuthSession(
      token: 'guest-$userId',
      issuedAt: DateTime.now(),
      user: profile,
    );
  }

  @override
  Future<AuthSession> signInWithGoogle({required String idToken}) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    final String userId = _randomId(prefix: 'google');
    final UserProfile profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      username: 'Nexora Player',
      email: 'player@nexora.dev',
      isGuest: false,
      level: 1,
      xp: 0,
      diamond: 50,
      hints: 3,
    );
    return AuthSession(
      token: 'token-$userId',
      refreshToken: 'refresh-$userId',
      issuedAt: DateTime.now(),
      user: profile,
    );
  }

  String _randomId({required String prefix}) {
    final Random rng = Random();
    final int suffix = rng.nextInt(900000) + 100000;
    return '$prefix-$suffix';
  }
}
