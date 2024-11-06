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

  List<Widget> pages = [
    const DashboardPage(),
    const StudentPage(),
    const SchedulePage(),
    const AccountPage(),
  ];

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

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedLabelStyle:
            Theme.of(context).textTheme.displaySmall!.merge(const TextStyle(
                  fontWeight: FontWeight.bold,
                )),
        unselectedLabelStyle: Theme.of(context).textTheme.displaySmall,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  FontAwesomeIcons.house,
                ),
              ),
              label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  FontAwesomeIcons.child,
                ),
              ),
              label: "Students"),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  FontAwesomeIcons.calendarCheck,
                ),
              ),
              label: "Schedule"),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  FontAwesomeIcons.userGear,
                ),
              ),
              label: "Account")
        ],
        currentIndex: currentIndex,
        onTap: onTapped,
      ),
      body: pages[currentIndex],
      /* bottomNavigationBar: NavBar(
        currentIndex: currentIndex,
        items: items,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        onTap: (value) {
          setPage(value);
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ), */
    );
  }
}
