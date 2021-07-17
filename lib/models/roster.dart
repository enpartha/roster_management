import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Roster with ChangeNotifier {
  String? id;
  String? memberId;
  DateTime? startDate;
  DateTime? endDate;
  List<Appointment> appointments;

  Roster({
    this.id,
    this.memberId,
    this.startDate,
    this.endDate,
    this.appointments = const [],
  });
}
