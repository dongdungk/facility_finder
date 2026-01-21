import 'package:flutter/material.dart';

class SupportTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  const SupportTile({super.key, 
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.15),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}