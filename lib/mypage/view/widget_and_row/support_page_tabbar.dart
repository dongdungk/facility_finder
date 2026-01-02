import 'package:flutter/material.dart';

import '../page/faq_tab_page.dart';
import '../page/notice_tab_page.dart';

class SupportPageTabbar extends StatelessWidget {
  const SupportPageTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const TabBar(
        tabs: [
            Tab(text: '공지사항'),
            Tab(text: '자주 묻는 질문'),
            // Tab(text: '1:1 문의'),
          ],
        ),
        body:  TabBarView(
          children: [
            SafeArea(child: NoticeTabPage()),
            SafeArea(child: FaqTabPage()),
            // Center(child: SafeArea(child: (),),),
          ],
        ),
      ),
    );
  }
}
