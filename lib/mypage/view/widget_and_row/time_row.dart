import 'package:flutter/material.dart';

import 'time_picker_field_widget.dart';

class TimeRow extends StatefulWidget {
  const TimeRow({super.key});

  @override
  State<TimeRow> createState() => _TimeRowState();
}

class _TimeRowState extends State<TimeRow> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _pickTime({
    required bool isStart,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '-- : --';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour : $minute';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TimePickerFieldWidget(
            label: '운영 시작 시간',
            value: _formatTime(startTime),
            onTap: () => _pickTime(isStart: true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TimePickerFieldWidget(
            label: '운영 종료 시간',
            value: _formatTime(endTime),
            onTap: () => _pickTime(isStart: false),
          ),
        ),
      ],
    );
  }
}