import 'package:flutter/material.dart';
import '../widget_and_row/form_widget.dart';

import '../widget_and_row/facility_input_widget.dart';

class AddFacilityStepForm2 extends StatelessWidget {
  const AddFacilityStepForm2({super.key});

  @override
  Widget build(BuildContext context) {
    return FormWidget(
      icon: Icons.description,
      title: '사업자 정보',
      child: Column(
        spacing: 10,
        children: [
          FacilityInputWidget(label: '사업자 등록번호', hint: '123-45-67890'),
          FacilityInputWidget(label: '대표자명', hint: '홍길동'),
          FacilityInputWidget(label: '대표자 연락처', hint: '010-1234-5678'),
          FacilityInputWidget(label: '이메일', hint: 'example@email.com'),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '사업자 정보는 시설 등록 심사를 위해 사용되며, 별도의 세금 계산에 활용될 수 있습니다.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}