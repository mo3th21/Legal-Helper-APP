import 'package:flutter/foundation.dart';
import '../models/user.dart';

enum AuthState {
  loading,
  authenticated,
  unauthenticated,
}

abstract class AuthProviderInterface with ChangeNotifier {
  AppUser? get user;
  AuthState get state;
  String? get errorMessage;
  bool get isAuthenticated;
  bool get isLoading;

  Future<void> initialize();
  Future<bool> signUp({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  });
  Future<bool> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<bool> sendEmailVerification();
  void clearError();
}


