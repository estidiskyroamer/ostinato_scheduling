import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/pages/dashboard/dashboard.dart';
import 'package:ostinato/pages/menu/menu.dart';
import 'package:ostinato/pages/schedule/schedule.dart';
import 'package:ostinato/pages/student/student.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;
  final PageController _controller = PageController();

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

  void onTapped(int index) {
    if (currentIndex != index) {
      _controller.jumpToPage(index);
    }

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
        backgroundColor: Theme.of(context).extension<OstinatoThemeExtension>()!.navBarColor,
        selectedLabelStyle: Theme.of(context).textTheme.displaySmall!.merge(const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        unselectedLabelStyle: Theme.of(context).textTheme.displaySmall,
        unselectedItemColor: Theme.of(context).extension<OstinatoThemeExtension>()!.navBarUnselectedItemColor,
        selectedItemColor: Theme.of(context).extension<OstinatoThemeExtension>()!.navBarSelectedItemColor,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  LucideIcons.house,
                ),
              ),
              label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  LucideIcons.users,
                ),
              ),
              label: "Students"),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  LucideIcons.calendarCheck,
                ),
              ),
              label: "Schedule"),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Icon(
                  LucideIcons.userCog,
                ),
              ),
              label: "Account")
        ],
        currentIndex: currentIndex,
        onTap: onTapped,
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: onTapped,
        children: pages,
      ),
    );
  }
}
