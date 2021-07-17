import 'package:roster_table_view/widgets/palette_drawer.dart';

import '../providers/roster_data.dart';

import '../models/member.dart';
// import '../providers/group_members.dart';
import '../screens/roster_management_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class GroupRoster extends StatefulWidget {
  final selectionColor;
  final rosterStartDate;
  final rosterEndDate;
  final groupMembers;
  const GroupRoster({
    Key? key,
    this.selectionColor,
    this.rosterStartDate,
    this.rosterEndDate,
    this.groupMembers,
  }) : super(key: key);

  @override
  _GroupRosterState createState() => _GroupRosterState();
}

class _GroupRosterState extends State<GroupRoster> {
  void _calendarTapped(CalendarTapDetails details, memberId) {
    _addAppointment(details, memberId);
  }

  void _addAppointment(CalendarTapDetails details, memberId) {
    final _selectedDate = details.date as DateTime;

    final _dutyDetails = PaletteDrawer.selectedDuty;
    // print(_dutyDetails?.dutyAbbreviation);

    if (ManageRoster.editMode &&
        _selectedDate.isAfter(DateTime.now()) &&
        _dutyDetails != null) {
      Provider.of<RosterData>(context, listen: false)
          .addNew(memberId, _selectedDate, _dutyDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Member> groupMembers = widget.groupMembers ?? [];
    var _headerCellColor = Colors.black87;
    Widget _calendarData(index, roster) {
      print(roster);
      List<Appointment> appointments = roster?.appointments ?? <Appointment>[];
      CalendarDataSource _dutyDataSource = _getCalendarDataSource(appointments);
      return Expanded(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Colors.blue, width: 1, style: BorderStyle.solid),
            ),
            color: Colors.white,
          ),
          child: SfCalendar(
            onTap: (details) {
              _calendarTapped(details, groupMembers[index].id);
            },

            headerHeight: 0,

            view: CalendarView.timelineMonth,

            minDate: widget.rosterStartDate,
            maxDate: widget.rosterEndDate,
            timeSlotViewSettings: TimeSlotViewSettings(
              timelineAppointmentHeight: 60,
              timeIntervalWidth: 50,
              dateFormat: 'd' + '/' + 'M',
              dayFormat: 'EE',
            ),
            // viewHeaderStyle: ViewHeaderStyle(dateTextStyle: ),

            todayHighlightColor: Colors.lightBlue,
            dataSource: _dutyDataSource,
          ),
        ),
      );
    }

    Widget _memberName(index) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: Colors.white, width: 1, style: BorderStyle.solid),
          ),
          color: _headerCellColor,
        ),
        height: 80,
        width: 100,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 10,
              ),
            ),
            Expanded(
              child: Text(
                groupMembers[index].name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> _buildRows(members, roster) {
      return List.generate(
        members.length,
        (index) => Row(
          children: [
            _memberName(index),
            _calendarData(index, roster[members[index].id])
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 32,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                      right: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    color: _headerCellColor,
                  ),
                  child: Center(
                    child: Text(
                      'Member',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 32,
                    color: _headerCellColor,

                    // verticalAlignment: TableCellVerticalAlignment.top,
                    child: Center(
                      child: Text(
                        'Schedule',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<RosterData>(
            builder: (context, roster, child) {
              return Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: _buildRows(groupMembers, roster.draftRoster),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DutyDataSource extends CalendarDataSource {
  DutyDataSource(List<Appointment> source) {
    appointments = source;
  }
}

DutyDataSource _getCalendarDataSource(appo) {
  return DutyDataSource(appo);
}
