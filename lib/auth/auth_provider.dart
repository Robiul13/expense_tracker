import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _service.currentUser != null;

  // 🔹 PRIVATE STATE HELPERS
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // ==========================
  // 🔹 REGISTER
  // ==========================
  Future<bool> register(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      await _service.register(email: email, password: password);

      return true;
    }

    on AuthException catch (e) {
      _setError(_mapAuthError(e.message));
      return false;
    }

    catch (_) {
      _setError("Registration failed. Please try again.");
      return false;
    }

    finally {
      _setLoading(false);
    }
  }

  // ==========================
  // 🔹 LOGIN
  // ==========================
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      await _service.login(email: email, password: password);

      return true;
    }

    on AuthException catch (e) {
      _setError(_mapAuthError(e.message));
      return false;
    }

    catch (_) {
      _setError("Login failed. Please try again.");
      return false;
    }

    finally {
      _setLoading(false);
    }
  }

  // ==========================
  // 🔹 LOGOUT
  // ==========================
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _service.logout();
    } catch (_) {
      _setError("Logout failed.");
    } finally {
      _setLoading(false);
    }
  }

  // ==========================
  // 🔹 ERROR MAPPING
  // ==========================
  String _mapAuthError(String message) {
    final msg = message.toLowerCase();

    if (msg.contains("invalid login credentials")) {
      return "Incorrect email or password.";
    }

    if (msg.contains("email not confirmed")) {
      return "Please verify your email first.";
    }

    if (msg.contains("user not found")) {
      return "No account found with this email.";
    }

    if (msg.contains("password")) {
      return "Password is incorrect.";
    }

    if (msg.contains("already registered")) {
      return "Email is already registered.";
    }

    if (msg.contains("network")) {
      return "No internet connection.";
    }

    return "Authentication failed. Please try again.";
  }
}
