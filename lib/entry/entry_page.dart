import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "입출입",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
