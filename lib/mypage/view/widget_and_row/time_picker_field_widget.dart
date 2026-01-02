import 'package:flutter/material.dart';

class TimePickerFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const TimePickerFieldWidget({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            hintText: value,
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}