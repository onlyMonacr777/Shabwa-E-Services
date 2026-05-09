import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إنشاء حساب
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'حدث خطأ';
    }
  }

  // تسجيل دخول
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'حدث خطأ';
    }
  }

  // تسجيل خروج
  Future<void> logout() async {
    await _auth.signOut();
  }

  // المستخدم الحالي
  User? get currentUser => _auth.currentUser;
}