import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/home.dart';

import './screens/roster_management_page.dart';

import './providers/group_members.dart';
import './providers/my_groups.dart';
import './providers/my_duty.dart';

import './providers/roster_data.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Groups(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MyDuty(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Members(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RosterData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CytoClick',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          accentColor: Colors.indigoAccent,
          fontFamily: 'Lato',
        ),
        home: HomePage(),
        routes: {
          ManageRoster.routeName: (ctx) => ManageRoster(),
        },
      ),
    );
  }
}
