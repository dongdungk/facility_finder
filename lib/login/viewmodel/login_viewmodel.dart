import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  User? _user;
  String? _errorMessage;

  LoginViewModel(this._authService);

  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========================================
  // 1. 이메일/비밀번호 회원가입
  // ========================================
  Future<bool> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authService.signUpWithEmail(email: email, password: password);

      if (user != null) {
        _user = user;
        _setLoading(false);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = '비밀번호는 6자 이상이어야 합니다.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = '이미 사용 중인 이메일입니다.';
      } else {
        _errorMessage = '회원가입에 실패했습니다: ${e.message}';
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다.';
      _setLoading(false);
      return false;
    }
  }

  // ========================================
  // 2. 이메일/비밀번호 로그인
  // ========================================
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authService.signInWithEmail(email: email, password: password);

      if (user != null) {
        _user = user;
        _setLoading(false);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _errorMessage = '이메일 또는 비밀번호가 일치하지 않습니다.';
      } else {
        _errorMessage = '로그인에 실패했습니다: ${e.message}';
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다.';
      _setLoading(false);
      return false;
    }
  }

  // ========================================
  // ⭐️ 3. [추가] 인증 메일 발송 래퍼 함수 ⭐️
  // ========================================
  Future<void> sendVerificationEmail() async {
    await _authService.sendEmailVerification();
  }

  // ========================================
  // 4. Google 로그인
  // ========================================
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        _user = user;
        _setLoading(false);
        return true;
      }
      // 사용자가 로그인 창을 닫았을 때 (googleUser == null)
      _setLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = 'Google 로그인에 실패했습니다: ${e.message}';
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다.';
      _setLoading(false);
      return false;
    }
  }

  // ========================================
  // 5. 로그아웃
  // ========================================
  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _user = null;
    _setLoading(false);
  }
}