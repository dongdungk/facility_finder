import 'package:flutter/material.dart';

class AddFacilityNextstepbutton extends StatelessWidget {
  const AddFacilityNextstepbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: Text('이전'),
            ),
          ),
           SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('다음 / 등록 신청'),
            ),
          ),
        ],
      ),
    );
  }
}
