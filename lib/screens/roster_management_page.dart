import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../widgets/palette_drawer.dart';
import '../widgets/bottom_drawer.dart';
import '../widgets/roster_page.dart';
import '../providers/my_groups.dart';
import '../models/group.dart';
import '../providers/group_members.dart';

class ManageRoster extends StatefulWidget {
  static const routeName = '/manage_roster';
  // static Duty? addDuty;
  static bool editMode = false;

  @override
  ManageRosterState createState() => ManageRosterState();
}

class ManageRosterState extends State<ManageRoster> {
  final CalendarController _controller = CalendarController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  bool _isOpen = false;
  BottomDrawerController _paletteController = BottomDrawerController();

  Color _selectionColor = Colors.transparent;
  DateTime? _rosterStartDate;
  DateTime? _rosterEndDate;

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  Group? _selectedGroup = Groups().items.length == 0 ? null : Groups().items[0];

  void _changeEndDate(date) {
    setState(() {
      _selectedEndDate = _selectedStartDate;
      _startDateController.text = date;
    });
  }

  void _toggleDrawer() {
    setState(() {
      if (_isOpen) {
        _paletteController.close();
        ManageRoster.editMode = false;
        PaletteDrawer.selectedDuty = null;

        _isOpen = false;
      } else {
        _paletteController.open();
        ManageRoster.editMode = true;

        _isOpen = true;
      }
    });
  }

  _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: _selectedStartDate,
        lastDate: _selectedStartDate.add(Duration(days: 120)));
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _rosterStartDate = picked;
        var date =
            "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";

        _startDateController.text = date;
        if (_selectedStartDate.isAfter(_selectedEndDate)) {
          _changeEndDate(date);
        }
      });
    }
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedStartDate,
        firstDate: _selectedStartDate,
        lastDate: DateTime(2025));
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _rosterEndDate = picked;
        var date =
            "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";

        _endDateController.text = date;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final myGroupsList = Provider.of<Groups>(context).items;
    final allMembers = Provider.of<Members>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Roster'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myGroupsList.isEmpty || _selectedGroup!.memberList.isEmpty
              ? Navigator.popAndPushNamed(context, '/manage_groups')
              : _toggleDrawer();
        },
        child: (_isOpen ? Icon(Icons.done_rounded) : Icon(Icons.add)),
        mini: ManageRoster.editMode ? true : false,
      ),
      floatingActionButtonLocation: !ManageRoster.editMode
          ? FloatingActionButtonLocation.miniEndFloat
          : FloatingActionButtonLocation.miniEndDocked,
      body: myGroupsList.isEmpty
          ? Center(
              child: Text('Please Create a Group First!'),
            )
          : _selectedGroup!.memberList.isEmpty
              ? Center(
                  child: Text('Please Add Members to the Group!'),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            child: Container(
                              height: deviceSize.height * 0.72,
                              child: GroupRoster(
                                groupMembers: allMembers
                                    .where((member) =>
                                        member.groupId == _selectedGroup!.id)
                                    .toList(),
                                selectionColor: _selectionColor,
                                rosterStartDate: _rosterStartDate,
                                rosterEndDate: _rosterEndDate,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 70, bottom: 4),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                DropdownButton(
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  // icon: Icon(Icons.arrow_drop_down),
                                  hint: Text("Select Group"),

                                  value: _selectedGroup != null
                                      ? _selectedGroup
                                      : myGroupsList.isEmpty
                                          ? _selectedGroup
                                          : myGroupsList[0],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGroup = value as Group;
                                      print(value.groupName);
                                    });
                                  },
                                  items: myGroupsList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.groupName),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: TextFormField(
                                          onTap: () =>
                                              _selectStartDate(context),
                                          readOnly: true,
                                          controller: _startDateController,
                                          decoration: InputDecoration(
                                            labelText: "From Date",
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: GestureDetector(
                                        child: TextFormField(
                                          onTap: () => _selectEndDate(context),
                                          readOnly: true,
                                          controller: _endDateController,
                                          // validator: (value) {
                                          //   DateTime _endDate =
                                          //       DateTime.parse(value as String);

                                          //   if (_endDate.isBefore(_startDate)) {
                                          //     return 'Invalid Input';
                                          //   }
                                          //   return null;
                                          // },
                                          decoration: InputDecoration(
                                            labelText: "To Date",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    PaletteDrawer(
                      controller: _paletteController,
                      bodyHeight: deviceSize.height * 0.16,
                    ),
                  ],
                ),
    );
  }
}
