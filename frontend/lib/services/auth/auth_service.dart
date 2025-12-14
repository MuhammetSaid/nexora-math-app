import 'dart:math';

import '../../models/user/auth_session.dart';
import '../../models/user/user_profile.dart';

/// Contract for talking to the backend auth endpoints.
abstract class AuthService {
  Future<AuthSession> signInAsGuest();

  Future<AuthSession> signInWithGoogle({required String idToken});
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
