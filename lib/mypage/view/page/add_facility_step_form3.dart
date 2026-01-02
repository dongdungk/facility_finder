import 'package:flutter/material.dart';

import '../widget_and_row/facility_input_widget.dart';
import '../widget_and_row/form_widget.dart';
import '../widget_and_row/time_row.dart';

class AddFacilityStepForm3 extends StatelessWidget {
  const AddFacilityStepForm3();

  @override
  Widget build(BuildContext context) {
    return FormWidget(
      icon: Icons.check_circle,
      title: '추가 정보',
      child: Column(
        spacing: 10,
        children: const [
          TimeRow(),
          FacilityInputWidget(label: '휴무일', hint: '매주 월요일, 공휴일'),
          FacilityInputWidget(label: '이용 요금', hint: '50,000원'),
          SizedBox(height: 12),
          // _ImageUploadBox(),
        ],
      ),
    );
  }
}