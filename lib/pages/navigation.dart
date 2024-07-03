import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ostinato/pages/schedule/schedule.dart';

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
              icon: Icon(FontAwesomeIcons.house), label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(FontAwesomeIcons.child), label: 'Students'),
          NavigationDestination(
              icon: Icon(FontAwesomeIcons.listOl), label: 'Schedule'),
          NavigationDestination(
              icon: Icon(FontAwesomeIcons.userGear), label: 'Account'),
        ],
        elevation: 0,
        backgroundColor: HexColor("#E6F2FF"),
        indicatorColor: HexColor("#CDD9E5"),
        indicatorShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      body: <Widget>[
        Container(
          color: Colors.red,
          child: const Text("Dashboard"),
        ),
        Container(
          color: Colors.blue,
          child: const Text("Students"),
        ),
        SchedulePage(),
        Container(
          color: Colors.yellow,
          child: const Text("Account"),
        ),
      ][currentIndex],
    );
  }
}
