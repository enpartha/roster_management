import 'package:flutter/material.dart';
import './roster_management_page.dart';
import '../providers/fetch_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _selectedPage = 1;

  // final _pages = <Widget>[ManageRoster()];

  // PageController _pageController = PageController();

  bool _isInit = true;

  bool _isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController(initialPage: 1);
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      fetchData(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Nursing Care'),
        //   actions: <Widget>[
        //     IconButton(
        //         icon: Icon(Icons.notifications),
        //         onPressed: () {
        //           Navigator.of(context).pushNamed('/notifications');
        //         }),
        //     // PopupMenu(),
        //   ],
        // ),
        // drawer: AppDrawer(),
        // body: _pageOptions[selectedPage],
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ManageRoster(),

        // bottomNavigationBar: BottomNavyBar(
        //   showElevation: true,

        //   // itemCornerRadius: ,
        //   selectedIndex: _selectedPage,
        //   onItemSelected: (index) {
        //     setState(
        //       () {
        //         _selectedPage = index;

        //         _pageController.animateToPage(index,
        //             duration: Duration(milliseconds: 300), curve: Curves.ease);
        //       },
        //     );
        //   },
        //   items: <BottomNavyBarItem>[
        //     BottomNavyBarItem(
        //         icon: Icon(Icons.room_preferences),
        //         title: Text("Preference"),
        //         activeColor: Theme.of(context).accentColor,
        //         inactiveColor: Colors.black),
        //     BottomNavyBarItem(
        //         icon: Icon(Icons.schedule),
        //         title: Text("Schedule"),
        //         activeColor: Theme.of(context).accentColor,
        //         inactiveColor: Colors.black),
        //     BottomNavyBarItem(
        //         icon: Icon(Icons.group),
        //         title: Text("Roster"),
        //         activeColor: Theme.of(context).accentColor,
        //         inactiveColor: Colors.black),
        //     BottomNavyBarItem(
        //         icon: Icon(Icons.import_contacts_outlined),
        //         title: Text("Knowledge"),
        //         activeColor: Theme.of(context).accentColor,
        //         inactiveColor: Colors.black),
        //   ],
        // ),
      ),
    );
  }
}
