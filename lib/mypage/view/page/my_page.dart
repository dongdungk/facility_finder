import '../widget_and_row//recent_entry_record_widget.dart';
import 'package:flutter/material.dart';

import '../widget_and_row/support_tile.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 40, 16, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3B5BFF), Color(0xFF6A6CFF)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '마이페이지',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 프로필 카드
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF4A6CF7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            /// 프로필 아이콘
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 12),

                            /// 이름 / 이메일
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '홍길동',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'hong@example.com',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// 화살표
                            Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: RecentEntryRecordWidget(),
                    ),
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '115',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                            Text('총 방문 횟수'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '4',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                            Text('방문한 시설'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: const [
                      SupportTile(
                        icon: Icons.notifications_none,
                        iconColor: Colors.orange,
                        title: '알림 설정',
                      ),
                      Divider(height: 1),
                      SupportTile(
                        icon: Icons.support_agent,
                        iconColor: Colors.green,
                        title: '고객센터',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A6CF7), Color(0xFF6A7CFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            '시설을 등록하고 싶은 자영업자라면',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '간편하게 시설을 등록하고 실시간 입출입 관리를 시작하세요',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: Text('시설 등록하기'),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.logout, color: Colors.red),
                        label: Text(
                          '로그아웃',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.maxFinite,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.person_off, color: Colors.grey),
                        label: Text(
                          '회원 탈퇴',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
