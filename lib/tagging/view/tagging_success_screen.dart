import 'package:flutter/material.dart';
// ⭐️ 1. [수정] go_router 패키지를 import 합니다.
import 'package:go_router/go_router.dart';

class TaggingSuccessScreen extends StatelessWidget {
  const TaggingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('입출입'),
        automaticallyImplyLeading: false, // '뒤로가기' 버튼 숨김
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. 성공 아이콘
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 24),
              // 2. 텍스트
              const Text(
                '태그 성공!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                '서초구민체육센터', // (임시)
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              const Text(
                '입실이 완료되었습니다',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const Spacer(), // 남은 공간을 밀어냄
              // 3. 확인 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  // ⭐️ 2. [수정] Navigator.popUntil -> context.go
                  // '/edit' 탭의 루트(첫 화면)로 이동합니다.
                  // '/tagging_success' 화면은 스택에서 자동으로 제거됩니다.
                  context.go('/edit');
                },
                child: const Text('확인', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }
}