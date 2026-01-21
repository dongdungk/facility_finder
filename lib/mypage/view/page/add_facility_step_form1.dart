import 'package:flutter/material.dart';
import '../widget_and_row/facility_input_widget.dart';

import '../widget_and_row/form_widget.dart';

class AddFacilityStepForm1 extends StatelessWidget {
  const AddFacilityStepForm1({super.key});

  @override
  Widget build(BuildContext context) {
    return FormWidget(
      icon: Icons.apartment,
      title: '시설 기본 정보',
      child: Container(
        child: Column(
          spacing: 10,
          children: [
            FacilityInputWidget(label: '시설명', hint: '*** 피시방'),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: '시설 유형',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              initialValue: '기타',
              items: const [
                DropdownMenuItem(value: '기타', child: Text('기타')),
              ],
              onChanged: (_) {},
            ),
            SizedBox(height: 5,),
            FacilityInputWidget(label: '주소', hint: '서울시 관악구 '),
            FacilityInputWidget(label: '상세 주소 (선택)'),
            FacilityInputWidget(label: '연락처', hint: '010-****-****'),
            FacilityInputWidget(label: '수용 인원', hint: '60'),

          ],
        ),
      ),
    );
  }
}