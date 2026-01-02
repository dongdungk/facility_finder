import 'package:flutter/material.dart';

import '../widget_and_row/support_page_tabbar.dart';
import '../widget_and_row/support_info_row.dart';


//support
class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const Icon(Icons.arrow_back, color: Colors.black),
          title: const Text(
            '고객센터',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          ),
        body: Container(
          child: Column(
            children: [
              // 고객센터 정보 카드
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2A5CFF),
                ),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5A6CF7), Color(0xFF6A7CFF)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('고객센터 연락처', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),),
                      SizedBox(height: 8),
                      SupportInfoRow(icon: Icons.call, text: '1588-0000'),
                      SizedBox(height: 8),
                      SupportInfoRow(icon: Icons.email, text: 'support@example.com'),
                      SizedBox(height: 8),
                      SupportInfoRow(icon: Icons.access_time, text: '평일 09:00 - 18:00'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width:double.maxFinite,
                height: double.maxFinite,
                child: SupportPageTabbar(),
              )
            ],
          ),
        ),
      );
  }
}