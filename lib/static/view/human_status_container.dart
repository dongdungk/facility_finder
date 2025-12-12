import 'package:flutter/material.dart';

class HumanStatusContainer extends StatelessWidget {
  final String hStatTitle;
  final double hPercent;
  const HumanStatusContainer({
    super.key,
    required this.hStatTitle,
    required this.hPercent,
  });

  @override
  Widget build(BuildContext context) {
    int _hPercent = hPercent.toInt();
    return Container(
      color: Color(0xffF9FAFB),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(hStatTitle), Text('$_hPercent%')],
      ),
    );
  }
}
