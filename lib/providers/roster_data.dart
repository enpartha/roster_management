import '../models/roster.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class RosterData with ChangeNotifier {
  Map<String, Roster>? pastRoster;
  Map<String, Roster>? presentRoster;
  Map<String, Roster>? futureRoster;

  Map<String, Roster> draftRoster = {
    'abc': Roster(
      id: 'def',
      memberId: 'abc',
      startDate: DateTime(2021, 7, 1),
      endDate: DateTime(2021, 7, 30),
      appointments: [
        Appointment(
          startTime: DateTime(2021, 7, 28, 10, 0, 0),
          endTime: DateTime(2021, 7, 28, 14, 0, 0),
          isAllDay: false,
          subject: 'Day',
          color: Colors.yellow[700] as Color,
          notes: 'A1',
          startTimeZone: '',
          endTimeZone: '',
        ),
        Appointment(
          startTime: DateTime(2021, 7, 26, 10, 0, 0),
          endTime: DateTime(2021, 7, 26, 14, 0, 0),
          isAllDay: true,
          subject: 'Leave',
          color: Colors.green,
          notes: 'A2',
          startTimeZone: '',
          endTimeZone: '',
        ),
      ],
    )
  };

  void addNew(String memberId, DateTime selectedDate, newDuty) {
    List<Appointment> appointments = draftRoster[memberId] == null
        ? []
        : draftRoster[memberId]!.appointments;
    int startHour = newDuty.dutyStartTime.hour;
    int startMinute = newDuty.dutyStartTime.minute;
    int endHour = newDuty.dutyEndTime.hour;
    int endMinute = newDuty.dutyEndTime.minute;
    DateTime startTime = selectedDate.add(
      Duration(
        hours: startHour,
        minutes: startMinute,
      ),
    );
    DateTime endTime = selectedDate.add(
      Duration(hours: endHour, minutes: endMinute),
    );

    print(selectedDate);

    final appointment = Appointment(
      startTime: startTime,
      endTime: endTime,
      isAllDay: !newDuty.onDuty,
      subject: newDuty.dutyName,
      color: newDuty.dutyColor,
      notes: newDuty.dutyAbbreviation,
      // startTimeZone: '',
      // endTimeZone: '',
    );
    appointments.add(appointment);
    draftRoster.putIfAbsent(memberId, () => Roster(appointments: appointments));

    print('draftRoster: ' + draftRoster[memberId]!.appointments.toString());

    print('Appointment added: ' + appointment.subject);
    notifyListeners();
  }
}
