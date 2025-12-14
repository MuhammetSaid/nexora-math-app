import 'package:flutter/foundation.dart';

import '../../models/user/auth_session.dart';
import 'auth_service.dart';

/// Simple session holder to orchestrate auth flows.
class AuthController extends ChangeNotifier {
  AuthController({required this.service});

  final AuthService service;
  AuthSession? _session;
  bool _loading = false;
  String? _lastError;

  AuthSession? get session => _session;
  bool get isAuthenticated => _session != null;
  bool get isGuest => _session?.isGuest ?? false;
  bool get isLoading => _loading;
  String? get lastError => _lastError;

  Future<AuthSession?> signInAsGuest() => _run(service.signInAsGuest);

  Future<AuthSession?> signInWithGoogle({required String idToken}) {
    return _run(() => service.signInWithGoogle(idToken: idToken));
  }

  Future<AuthSession?> _run(Future<AuthSession> Function() action) async {
    if (_loading) return _session;
    _setLoading(true);
    _lastError = null;
    try {
      final AuthSession result = await action();
      _session = result;
      notifyListeners();
      return result;
    } catch (error, stackTrace) {
      debugPrint('Auth flow failed: $error\n$stackTrace');
      _lastError = error.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _session = null;
    notifyListeners();
  }

  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }
}
