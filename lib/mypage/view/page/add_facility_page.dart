import 'package:flutter/material.dart';
import '../widget_and_row/add_facility_nextstepbutton.dart';
import '../page/add_facility_step_form1.dart';

import '../page/add_facility_step_form2.dart';
import '../page/add_facility_step_form3.dart';
import '../widget_and_row/add_facility_step_widget.dart';

class AddFacilityPage extends StatelessWidget {
  const AddFacilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          '시설 등록',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          StepIndicator(currentStep: 1),

          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                AddFacilityStepForm1(),
                AddFacilityStepForm2(),
                AddFacilityStepForm3(),
              ],
            ),
          ),

          //하단 버튼 추가(다음/이전)
          AddFacilityNextstepbutton()
        ],
      ),
    );
  }
}