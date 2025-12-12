import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/login_viewmodel.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 개인정보 처리 동의 상태
  bool _isPrivacyAgreed = false;

  bool _isLoginMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 약관을 보여주는 모달 함수
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('개인정보 수집 및 이용 동의 (필수)'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '회원가입 및 서비스 이용을 위한 필수적인 동의사항입니다.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('수집 항목: 이메일, 비밀번호 (필수), 사용자 계정 ID(UID).', style: TextStyle(fontWeight: FontWeight.w600)),
                const Text('수집 목적: 서비스 제공, 본인 확인 및 불량 이용 방지.'),
                const Text('보유 기간: 회원 탈퇴 시까지 원칙적으로 보유.'),
                const Divider(),
                const Text('개인정보 수집 및 이용에 동의하지 않을 권리가 있습니다.'),
                const Text('동의 거부에 따른 불이익:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                const Text('본 동의는 회원가입 및 서비스 이용을 위해 필수적이므로, 동의를 거부할 경우 회원가입 및 서비스 이용이 불가능합니다.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  // ========================================
  // 공통 로그인/회원가입 처리 함수
  // ========================================
  void _processAuth(BuildContext context, LoginViewModel viewModel) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일과 비밀번호를 입력해주세요.')),
      );
      return;
    }

    // 회원가입 모드에서 약관 미동의 시 바로 리턴
    if (!_isLoginMode && !_isPrivacyAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('개인정보 수집 및 이용에 동의해야 회원가입이 가능합니다.')),
      );
      return;
    }


    bool success;
    if (_isLoginMode) {
      // 로그인 시도
      success = await viewModel.signInWithEmail(email, password);
    } else {
      // 회원가입 시도
      success = await viewModel.signUpWithEmail(email, password);

      if (success) {
        await viewModel.sendVerificationEmail();
      }
    }

    if (success) {
      if (_isLoginMode) {
        // 1. 로그인 성공 시
        print('로그인 성공! (마이크로태스크 전환)');
        if (!context.mounted) return;

        // 메인 화면으로 이동
        Future.microtask(() {
          if (!context.mounted) return;
          context.go('/');
        });

      } else {
        // 2. 회원가입 성공 시 (인증 메일 전송 후 로그인 화면으로 전환)
        print('회원가입 성공! (인증 메일 전송 완료)');

        // 스낵바 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 완료되었습니다. 이메일 인증 후 로그인 화면에서 다시 로그인해주세요.')),
        );

        // 로그인 모드로 전환 및 필드 초기화
        setState(() {
          _isLoginMode = true;
          _passwordController.clear();
          _isPrivacyAgreed = false;
        });
      }

    } else {
      // 로그인/회원가입 실패 - ViewModel의 에러 메시지 표시
      if (viewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.errorMessage!)),
        );
        viewModel.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // 1. 상단 영역 (일러스트)
                      SizedBox(height: 50),
                      Image.asset(
                        'assets/panda.webp',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 30),

                      Text(
                          '환영합니다!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 30),

                      // 2. 이메일/비밀번호 입력 필드
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: '이메일',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: Icon(Icons.lock),
                          hintText: _isLoginMode ? null : '6자 이상 입력해주세요',
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 24),

                      // 3. 개인정보 동의 UI (회원가입 모드일 때만 표시)
                      if (!_isLoginMode)
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isPrivacyAgreed,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _isPrivacyAgreed = newValue ?? false;
                                    });
                                  },
                                ),
                                // ⭐️ [오버플로우 해결] Flexible로 Text 감싸기
                                Flexible(
                                  child: const Text(
                                    '개인정보 수집 및 이용에 동의합니다. (필수)',
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 14), // 폰트 크기 조정 고려
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _showPrivacyPolicy(context),
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(0, 0)
                                  ),
                                  child: const Text(
                                    '[약관 보기]',
                                    style: TextStyle(decoration: TextDecoration.underline, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),

                      // 4. 로그인/회원가입 버튼
                      ElevatedButton(
                        onPressed: (viewModel.isLoading || (!_isLoginMode && !_isPrivacyAgreed))
                            ? null
                            : () => _processAuth(context, viewModel),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 56),
                          backgroundColor: Color(0xFF5A4FCF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          _isLoginMode ? '로그인 하기' : '회원가입 하기',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 12),

                      // 로그인/회원가입 모드 전환 버튼
                      TextButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
                          setState(() {
                            _isLoginMode = !_isLoginMode;
                            if (_isLoginMode) {
                              _isPrivacyAgreed = false;
                            }
                            viewModel.clearError();
                          });
                        },
                        child: Text(
                          _isLoginMode ? '계정이 없으신가요? 회원가입 하러가기' : '이미 계정이 있으신가요? 로그인 하러가기',
                          style: TextStyle(color: Color(0xFF5A4FCF)),
                        ),
                      ),

                      SizedBox(height: 30),

                      // 5. 소셜 로그인 구분선
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text('또는 소셜 계정으로 시작하기', style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 20),

                      // 6. Google 로그인 버튼
                      _buildGoogleButton(context, viewModel),

                      SizedBox(height: 50), // 하단 여백

                    ],
                  ),
                ),

                // 로딩 인디케이터
                if (viewModel.isLoading)
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Google 로그인 버튼 함수 (변경 없음)
  Widget _buildGoogleButton(BuildContext context, LoginViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.isLoading ? null : () async {
        bool success = await viewModel.signInWithGoogle();

        if (success) {
          print('Google 로그인 성공! (마이크로태스크 전환)');

          if (!context.mounted) return;
          Future.microtask(() {
            if (!context.mounted) return;
            context.go('/');
          });

        } else {
          // 로그인 실패 - 에러 메시지 표시
          if (viewModel.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(viewModel.errorMessage!)),
            );
            viewModel.clearError();
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/google_logo.png',
              width: 24,
              height: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Google로 시작하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}