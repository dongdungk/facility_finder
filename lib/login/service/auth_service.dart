import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ========================================
  // 1. 상태 감지
  // ========================================
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // ========================================
  // 2. 이메일/비밀번호 회원가입
  // ========================================
  Future<User?> signUpWithEmail({required String email, required String password}) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // 에러 코드 처리 (예: 이메일 형식 오류, 비밀번호 약함 등)
      print("Firebase Auth Error: ${e.code}");
      rethrow;
    } catch (e) {
      print("Error during email sign up: $e");
      rethrow;
    }
  }

  // ========================================
  // 3. 이메일/비밀번호 로그인
  // ========================================
  Future<User?> signInWithEmail({required String email, required String password}) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // 에러 코드 처리 (예: 사용자 없음, 비밀번호 불일치)
      print("Firebase Auth Error: ${e.code}");
      rethrow;
    } catch (e) {
      print("Error during email sign in: $e");
      rethrow;
    }
  }

  // ========================================
  // 4. [추가] 이메일 인증 메일 발송
  // ========================================
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;

    // 현재 사용자가 로그인되어 있고, 아직 이메일 인증이 완료되지 않았다면 메일 발송
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print("Verification email sent to ${user.email}");
      } catch (e) {
        print("Error sending verification email: $e");
        // 메일 발송 오류가 발생해도 사용자에게는 가입이 되었다고 안내해야 합니다.
      }
    }
  }

  // ========================================
  // 5. Google 로그인
  // ========================================
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // 사용자가 Google 로그인 창을 닫았을 때
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;

    } on FirebaseAuthException catch (e) {
      print("Firebase Google Auth Error: ${e.code}");
      rethrow;
    } catch (e) {
      print("Error during Google sign in: $e");
      rethrow;
    }
  }

  // ========================================
  // 6. 로그아웃
  // ========================================
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}