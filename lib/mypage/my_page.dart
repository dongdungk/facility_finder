import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "내 정보",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
