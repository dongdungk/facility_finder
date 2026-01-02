import 'package:flutter/material.dart';
import 'visit_row.dart';

class RecentEntryRecordWidget extends StatelessWidget {
  const RecentEntryRecordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Colors.blue),
              SizedBox(width: 8),
              Text('최근 입출입 기록',style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 12),
          VisitRow(
            facilityName: '강남구청구민체육센터',
            visitTime: '2025-12-12. 오후 3:24:17',
            statusText: '입장',
          ),
          VisitRow(
            facilityName: '강남구청구민체육센터',
            visitTime: '2025-12-12. 오후 3:24:17',
            statusText: '입장',
          ),
          VisitRow(
            facilityName: '강남구청구민체육센터',
            visitTime: '2025-12-12. 오후 3:24:17',
            statusText: '입장',
          ),
          VisitRow(
            facilityName: '강남구청구민체육센터',
            visitTime: '2025-12-12. 오후 3:24:17',
            statusText: '입장',
          ),
        ],
      ),
    );
  }
}
