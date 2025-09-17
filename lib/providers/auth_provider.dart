import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'auth_provider_interface.dart';

class AuthProvider extends ChangeNotifier implements AuthProviderInterface {
  final AuthService _authService = AuthService();
  
  AppUser? _user;
  AuthState _state = AuthState.loading;
  String? _errorMessage;

  @override
  AppUser? get user => _user;
  @override
  AuthState get state => _state;
  @override
  String? get errorMessage => _errorMessage;
  @override
  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  @override
  bool get isLoading => _state == AuthState.loading;

  /// Initialize the auth provider
  @override
  Future<void> initialize() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await _authService.initialize();
      
      // Listen to auth state changes
      _authService.userStream.listen((AppUser? user) {
        _user = user;
        _state = user != null ? AuthState.authenticated : AuthState.unauthenticated;
        _errorMessage = null;
        notifyListeners();
      });

      // Set initial state
      _user = _authService.currentUser;
      _state = _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    } catch (e) {
    debugPrint('Auth provider initialization failed: $e');
      _state = AuthState.unauthenticated;
      _errorMessage = null; // Don't show error to user, just proceed without auth
    }
    
    notifyListeners();
  }

  /// Sign up with email and password
  @override
  Future<bool> signUp({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  }) async {
    _clearError();
    _state = AuthState.loading;
    notifyListeners();

    try {
      final result = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );

      if (result.success && result.user != null) {
        _user = result.user;
        _state = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _state = AuthState.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ غير متوقع: ${e.toString()}';
      _state = AuthState.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with email and password
  @override
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _clearError();
    _state = AuthState.loading;
    notifyListeners();

    try {
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.success && result.user != null) {
        _user = result.user;
        _state = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _state = AuthState.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ غير متوقع: ${e.toString()}';
      _state = AuthState.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  @override
  Future<void> signOut() async {
    try {
      // تسجيل خروج من Firebase عبر AuthService
      await _authService.signOut();
      
      // تنظيف SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // أو استخدم remove لمفاتيح محددة
      
      // تحديث حالة المستخدم
      _user = null;
      
      // إشعار المستمعين بالتغيير
      notifyListeners();
      
      print('تم تسجيل الخروج وتنظيف الجلسة بنجاح');
    } catch (e) {
      print('خطأ في تسجيل الخروج: $e');
      rethrow; // إعادة رمي الخطأ ليتم التعامل معه في UI
    }
  }

  /// Send email verification
  @override
  Future<bool> sendEmailVerification() async {
    _clearError();

    try {
      final result = await _authService.sendEmailVerification();
      
      if (!result.success) {
        _errorMessage = result.error;
        notifyListeners();
        return false;
      }
      
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ غير متوقع: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }



  /// Clear error message
  void _clearError() {
    _errorMessage = null;
  }

  /// Clear error message (public)
  @override
  void clearError() {
    _clearError();
    notifyListeners();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }
}
