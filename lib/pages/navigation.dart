import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ostinato/common/component.dart';
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
  void setPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<BottomNavBarItem> items = [
    BottomNavBarItem(
        label: "Dashboard",
        icon: FontAwesomeIcons.house,
        page: const DashboardPage()),
    BottomNavBarItem(
        label: "Students",
        icon: FontAwesomeIcons.child,
        page: const StudentPage()),
    BottomNavBarItem(
        label: "Schedule",
        icon: FontAwesomeIcons.calendarCheck,
        page: const SchedulePage()),
    BottomNavBarItem(
        label: "Account",
        icon: FontAwesomeIcons.userGear,
        page: const AccountPage()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBar(
          currentIndex: currentIndex,
          items: items,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          onTap: (value) {
            setPage(value);
          },
        ),
        body: items[currentIndex].page);
  }
}
