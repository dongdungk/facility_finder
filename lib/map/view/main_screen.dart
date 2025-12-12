// lib/main_screen.dart
// (기존 import들은 대부분 필요 없고, go_router도 필요 없습니다)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ⭐️ StatefulNavigationShell을 위해 필요

// StatelessWidget으로 변경해도 충분합니다.
class MainScreen extends StatelessWidget {

  // go_router가 전달해주는 'navigationShell'
  // 이 셸이 현재 탭 인덱스와 탭 이동 기능을 모두 가지고 있습니다.
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    // ‼ 기존의 모든 로직(State, _selectedIndex, _onBottomNavItemTapped 등) 삭제 ️

    return Scaffold(
      resizeToAvoidBottomInset: false,

      //  셸이 알아서 현재 탭에 맞는 화면을 여기에 표시합니다.
      body: navigationShell,

      // 하단 탭 바
      bottomNavigationBar: BottomNavigationBar(
        // 현재 인덱스도 셸이 알려줍니다.
        currentIndex: navigationShell.currentIndex,

        // 탭 변경도 셸에게 맡깁니다.
        onTap: (index) {
          navigationShell.goBranch(
            index,
            // 탭을 다시 눌렀을 때 스택의 첫 페이지로 갈지 여부
            initialLocation: index == navigationShell.currentIndex,
          );
        },

        // --- (이하 탭 아이템은 동일) ---
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
          //BottomNavigationBarItem(icon: Icon(Icons.location_pin), label: '입출입'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: '커뮤니티'),
          //BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}