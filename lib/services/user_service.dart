import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// خدمة إدارة بيانات المستخدمين في Firestore - حفظ وتحديث وجلب بيانات المستخدمين
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  /// حفظ بيانات المستخدم في Firestore عند إنشاء حساب جديد
  Future<bool> saveUser(AppUser user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'phoneNumber': user.phoneNumber,
        'createdAt': user.createdAt,
        'updatedAt': DateTime.now(),
        'profileComplete': false,
      });
      
      debugPrint('User data saved successfully for UID: ${user.uid}');
      return true;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      return false;
    }
  }

  /// جلب بيانات المستخدم من Firestore باستخدام UID
  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return AppUser.fromJson(data);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  /// تحديث بيانات المستخدم في Firestore - يضيف تاريخ التحديث تلقائياً
  Future<bool> updateUser(String uid, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = DateTime.now();
      
      await _firestore.collection(_usersCollection).doc(uid).update(updates);
      
      debugPrint('User data updated successfully for UID: $uid');
      return true;
    } catch (e) {
      debugPrint('Error updating user data: $e');
      return false;
    }
  }

  /// فحص ما إذا كان المستخدم موجود في Firestore أم لا
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking if user exists: $e');
      return false;
    }
  }
}
