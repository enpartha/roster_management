import '../models/duty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'bottom_drawer.dart';
import '../models/palette_item.dart';

import '../providers/my_duty.dart';

class PaletteDrawer extends StatelessWidget {
  final double bodyHeight;
  static Duty? selectedDuty;

  const PaletteDrawer({
    Key? key,
    required BottomDrawerController controller,
    required this.bodyHeight,
  })   : _controller = controller,
        super(key: key);

  final BottomDrawerController _controller;

  @override
  Widget build(BuildContext context) {
    return BottomDrawer(
      // header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      // headerHeight: _headerHeight,
      drawerHeight: bodyHeight + kBottomNavigationBarHeight,
      color: Colors.black.withAlpha(15),
      controller: _controller,
      cornerRadius: 0,
    );
  }

  _buildBottomDrawerBody(BuildContext context) {
    final duty = Provider.of<MyDuty>(context).items;
    // MyCalendarState myCalendar = MyCalendarState();

    // Color? selectionColor;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: bodyHeight * 0.2,
              alignment: Alignment.center,
              child: Text(
                'Duty',
                style: TextStyle(
                  fontSize: bodyHeight * 0.17,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(-2, -2),
                    )
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: bodyHeight * 0.2,
              child: Text(
                'Leave',
                style: TextStyle(fontSize: bodyHeight * 0.17),
              ),
            ),
          ],
        ),
        Container(
          height: bodyHeight * 0.7,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: duty.length,
            itemBuilder: (BuildContext ctx, int i) {
              return Row(
                children: [
                  PaletteItem(
                    paletteColor: duty[i].dutyColor,
                    paletteText: duty[i].dutyAbbreviation,
                    paletteAction: () {
                      PaletteDrawer.selectedDuty = duty[i];
                      // print(i);
                      // print(MyCalendar.addDuty!.dutyColor);
                      // print(MyCalendar.addDuty!.dutyAbbreviation);
                      print('paletteAction');
                      // myCalendar.setSelectionColor();

                      // MyCalendar.selectDuty;

                      // PaletteItem.addDuty = duty[i];
                      // print(MyCalendar.editMode);
                      // print(PaletteItem.addDuty!.onDuty);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
