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
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedIndex: currentIndex,
        destinations: [
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.house,
                color: Colors.grey[700],
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.house,
                color: HexColor("#E6F2FF"),
              ),
              label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.child,
                color: Colors.grey[700],
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.child,
                color: HexColor("#E6F2FF"),
              ),
              label: 'Students'),
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.calendarCheck,
                color: Colors.grey[700],
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.calendarCheck,
                color: HexColor("#E6F2FF"),
              ),
              label: 'Schedule'),
          NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.userGear,
                color: Colors.grey[700],
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.userGear,
                color: HexColor("#E6F2FF"),
              ),
              label: 'Account'),
        ],
        elevation: 0,
        backgroundColor: HexColor("#E6F2FF"),
        indicatorColor: Colors.grey[700],
        indicatorShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      body: <Widget>[
        const DashboardPage(),
        const StudentPage(),
        const SchedulePage(),
        const AccountPage(),
      ][currentIndex],
    );
  }
}
