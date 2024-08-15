import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ostinato/pages/account/account.dart';
import 'package:ostinato/pages/dashboard/dashboard.dart';
import 'package:ostinato/pages/schedule/schedule.dart';
import 'package:ostinato/pages/student/student.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedIndex: currentIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.house,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.house,
                color: Colors.black,
              ),
              label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.child,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.child,
                color: Colors.black,
              ),
              label: 'Students'),
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.calendarCheck,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.calendarCheck,
                color: Colors.black,
              ),
              label: 'Schedule'),
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.userGear,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.userGear,
                color: Colors.black,
              ),
              label: 'Account'),
        ],
        elevation: 0,
        backgroundColor: HexColor("#E6F2FF"),
        indicatorColor: HexColor("#DFEBF8"),
        indicatorShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      body: <Widget>[
        DashboardPage(),
        StudentPage(),
        SchedulePage(),
        AccountPage(),
      ][currentIndex],
    );
  }
}
