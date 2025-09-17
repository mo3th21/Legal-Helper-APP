import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'user_service.dart';

/// نتيجة عمليات المصادقة - تحتوي على حالة النجاح/الفشل والبيانات
class AuthResult {
  final bool success;
  final String? error;
  final AppUser? user;

  const AuthResult({
    required this.success,
    this.error,
    this.user,
  });

  /// إنشاء نتيجة ناجحة مع بيانات المستخدم
  factory AuthResult.success(AppUser user) {
    return AuthResult(success: true, user: user);
  }

  /// إنشاء نتيجة فاشلة مع رسالة الخطأ
  factory AuthResult.failure(String error) {
    return AuthResult(success: false, error: error);
  }
}

/// خدمة المصادقة الأساسية - إدارة تسجيل الدخول والخروج وحسابات المستخدمين
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final StreamController<AppUser?> _userController = StreamController<AppUser?>.broadcast();
  final UserService _userService = UserService();

  /// تدفق بيانات المستخدم الحالي - يتحديث عند تغيير حالة المصادقة
  Stream<AppUser?> get userStream => _userController.stream;
  
  /// الحصول على المستخدم الحالي من Firebase Auth
  AppUser? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser != null ? AppUser.fromFirebaseUser(firebaseUser) : null;
  }

  /// فحص ما إذا كان المستخدم مسجل الدخول أم لا
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// تهيئة خدمة المصادقة - الاستماع لتغييرات حالة المصادقة وتحميل بيانات المستخدم
  Future<void> initialize() async {
    try {
      // الاستماع لتغييرات حالة Firebase Auth وتفضيل بيانات Firestore
      _firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
        if (firebaseUser != null) {
          // محاولة تحميل المستخدم من Firestore (قد يحتوي على رقم الهاتف وبيانات إضافية)
          final firestoreUser = await _userService.getUser(firebaseUser.uid);
          final appUser = firestoreUser ?? AppUser.fromFirebaseUser(firebaseUser);
          _userController.add(appUser);
          _saveUserToPreferences(appUser);
        } else {
          _userController.add(null);
          _clearUserFromPreferences();
        }
      });

      // إرسال المستخدم الحالي إذا كان متاحاً
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        // تفضيل Firestore أولاً (يحتفظ برقم الهاتف والحقول الأخرى)
        final firestoreUser = await _userService.getUser(firebaseUser.uid);
        final appUser = firestoreUser ?? AppUser.fromFirebaseUser(firebaseUser);
        _userController.add(appUser);
        _saveUserToPreferences(appUser);
      }
    } catch (e) {
      debugPrint('AuthService initialization failed: $e');
      // إرسال null للإشارة إلى عدم توفر المصادقة
      _userController.add(null);
      rethrow;
    }
  }

  /// إنشاء حساب جديد بالإيميل وكلمة المرور - مع حفظ البيانات في Firestore وإرسال تأكيد الإيميل
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // تحديث الاسم المعروض إذا تم توفيره
        if (displayName != null && displayName.isNotEmpty) {
          await credential.user!.updateDisplayName(displayName.trim());
          await credential.user!.reload();
        }

        // إرسال رسالة تأكيد الإيميل
        await credential.user!.sendEmailVerification();

        // إنشاء كائن AppUser مع البيانات المخصصة
        final user = AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email ?? '',
          displayName: displayName,
          phoneNumber: phoneNumber,
          createdAt: credential.user!.metadata.creationTime ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        // حفظ بيانات المستخدم في Firestore
        final userSaved = await _userService.saveUser(user);
        if (userSaved) {
          debugPrint('User data saved to Firestore collection successfully');
        } else {
          debugPrint('Warning: User created in Firebase Auth but failed to save to Firestore');
        }

        return AuthResult.success(user);
      } else {
        return AuthResult.failure('فشل في إنشاء الحساب');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  /// تسجيل الدخول بالإيميل وكلمة المرور - مع تحديث آخر وقت دخول في Firestore
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        // تفضيل مستند Firestore إذا كان متاحاً (قد يتضمن رقم الهاتف)
        final firebaseUser = credential.user!;
        final firestoreUser = await _userService.getUser(firebaseUser.uid);
        final user = firestoreUser ?? AppUser.fromFirebaseUser(firebaseUser);

        // التأكد من حفظ المستخدم في Firestore
        final userExists = await _userService.userExists(user.uid);
        if (!userExists) {
          debugPrint('User not found in Firestore, saving user data...');
          await _userService.saveUser(user);
        } else {
          // تحديث وقت آخر تسجيل دخول في Firestore
          await _userService.updateUser(user.uid, {
            'lastSignInAt': DateTime.now(),
          });
        }

        return AuthResult.success(user);
      } else {
        return AuthResult.failure('فشل في تسجيل الدخول');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  /// تسجيل الخروج - إلغاء جلسة Firebase Auth وحذف البيانات المحلية
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// إرسال رسالة تأكيد الإيميل للمستخدم الحالي (إذا لم يتم التأكيد بعد)
  Future<AuthResult> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return AuthResult.success(AppUser.fromFirebaseUser(user));
      } else {
        return AuthResult.failure('المستخدم غير موجود أو تم التحقق من الإيميل بالفعل');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  /// حفظ بيانات المستخدم في SharedPreferences للوصول السريع
  Future<void> _saveUserToPreferences(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', user.toJson().toString());
  }

  /// حذف بيانات المستخدم من SharedPreferences عند تسجيل الخروج
  Future<void> _clearUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  /// تحويل رموز أخطاء Firebase إلى رسائل باللغة العربية مفهومة للمستخدم
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'too-many-requests':
        return 'محاولات كثيرة، حاول مرة أخرى لاحقاً';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة';
      case 'invalid-credential':
        return 'بيانات الاعتماد غير صحيحة';
      case 'account-exists-with-different-credential':
        return 'يوجد حساب بنفس البريد مع طريقة دخول مختلفة';
      case 'requires-recent-login':
        return 'يتطلب تسجيل دخول حديث';
      default:
        return 'حدث خطأ: $errorCode';
    }
  }

  /// تنظيف الموارد وإغلاق Stream Controller عند عدم الحاجة للخدمة
  void dispose() {
    _userController.close();
  }
}
