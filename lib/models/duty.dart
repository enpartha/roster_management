import 'package:flutter/material.dart';

class Duty with ChangeNotifier {
  final String dutyName;
  String dutyAbbreviation;
  Color dutyColor;
  bool onDuty;
  bool isAllDay = false;
  String? id;
  TimeOfDay dutyStartTime;
  TimeOfDay dutyEndTime;

  Duty({
    required this.dutyName,
    this.dutyColor = Colors.grey,
    String dutyAbbreviation = '',
    this.onDuty = true,
    this.isAllDay = false,
    TimeOfDay dutyStartTime = const TimeOfDay(hour: 00, minute: 00),
    TimeOfDay dutyEndTime = const TimeOfDay(hour: 00, minute: 00),
    required this.id,
  })   : dutyAbbreviation = dutyAbbreviation.isEmpty
            ? dutyName.isEmpty
                ? ''
                : ('${dutyName.toUpperCase()[0]}' +
                    '${dutyName.toUpperCase()[1]}')
            : dutyAbbreviation,
        dutyStartTime =
            isAllDay ? TimeOfDay(hour: 00, minute: 00) : dutyStartTime,
        dutyEndTime = isAllDay ? TimeOfDay(hour: 24, minute: 00) : dutyEndTime;
}
