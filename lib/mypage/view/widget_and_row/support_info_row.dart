import 'package:flutter/material.dart';

class SupportInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const SupportInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
