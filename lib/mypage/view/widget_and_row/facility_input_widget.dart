import 'package:flutter/material.dart';

class FacilityInputWidget extends StatelessWidget {
  final String? label;
  final String? hint;

  const FacilityInputWidget({super.key, required this.label, this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
    );
  }
}