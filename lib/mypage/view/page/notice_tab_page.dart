import 'package:flutter/material.dart';
import '../widget_and_row/support_text_card.dart';

class NoticeTabPage extends StatelessWidget {
  const NoticeTabPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SupportTextCard(
          category: '공지',
          title: '서비스 점검 안내',
          contents:
              '더 나은 서비스 제공을 위해 12월 30일 새벽 2시부터 4시까지 서버 점검이 진행됩니다. 점검 시간 동안 서비스 이용이 제한될 수 있습니다.',
        ),
        SupportTextCard(
          category: '업데이트',
          title: '신규 기능 추가 안내',
          contents: '시설 검색 화면이 새롭게 개선되었으며, 시설 등록 시 이미지 자동 추가 기능이 추가되었습니다.',
        ),
        SupportTextCard(
          category: '공지',
          title: '연말연시 고객센터 운영 안내',
          contents:
              '12월 31일부터 1월 2일까지 고객센터 운영이 제한됩니다. 긴급 문의는 이메일로 접수해주시면 순차적으로 답변드리겠습니다.',
        ),
        SupportTextCard(
          category: '이벤트',
          title: '신규 회원 가입 이벤트',
          contents: '신규 회원 가입 시 첫 달 이용권 50% 할인! 2025년 1월 15일까지 진행됩니다.',
        ),
        SupportTextCard(
          category: '업데이트',
          title: '앱 버전 2.0 업데이트',
          contents: '로그인 기능이 추가되었으며, 전반적인 UI/UX가 개선되었습니다. 최신 버전으로 업데이트 해주세요.',
        ),
      ],
    );
  }
}
