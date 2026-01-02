import 'package:flutter/material.dart';

import '../widget_and_row/support_text_card.dart';

class FaqTabPage extends StatelessWidget {
  const FaqTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          SupportTextCard(
            category: '이용 방법',
            title: 'QR 코드는 어떻게 스캔하나요?',
            contents: '앱 하단의 QR 스캔 버튼을 눌러 카메라로 시설 입구의 QR 코드를 스캔하면 자동으로 입장 처리됩니다. 카메라 권한이 필요합니다.',
          ),
          SupportTextCard(
            category: '이용 방법',
            title: '퇴장은 어떻게 하나요?',
            contents: '시설 세부정보 페이지나 QR 스캔 페이지에서 "퇴장하기" 버튼을 누르면 퇴장 처리됩니다. 퇴장은 QR 스캔 없이 버튼으로만 가능합니다.',
          ),
          SupportTextCard(
            category: '계정',
            title: '비밀번호를 잊어버렸어요.',
            contents: '로그인 화면에서 "비밀번호 찾기"를 클릭하고 가입 시 등록한 이메일을 입력하면 비밀번호 재설정 링크가 발송됩니다.',
          ),
          SupportTextCard(
            category: '기능',
            title: '즐겨찾기는 어떻게 추가하나요?',
            contents: '시설 세부정보 페이지 상단의 별 아이콘을 탭하면 즐겨찾기에 추가/제거할 수 있습니다. 추가된 즐겨찾기는 지도 화면에서 확인할 수 있습니다.',
          ),
        ],
      ),
    );
  }
}
