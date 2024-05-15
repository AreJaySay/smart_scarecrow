import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smart_scarecrow/screens/home/home.dart';
import 'package:smart_scarecrow/screens/reports/report.dart';
import 'package:smart_scarecrow/services/stream/show_notification.dart';
import 'package:smart_scarecrow/utils/palettes/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    showNotificationStreamServices.updateRecord(data: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: showNotificationStreamServices.subject,
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: [
              PersistentTabView(
                context,
                controller: _controller,
                screens: [
                  Home(),
                  Report(),
                ],
                items: [
                  PersistentBottomNavBarItem(
                    icon: Icon(Icons.home),
                    title: "Home",
                    activeColorPrimary: AppColors.green,
                    inactiveColorPrimary: Colors.grey,
                  ),
                  PersistentBottomNavBarItem(
                    icon: Icon(Icons.file_present_rounded),
                    title: "Log Reports",
                    activeColorPrimary: AppColors.green,
                    inactiveColorPrimary: Colors.grey,
                  ),
                ],
                confineInSafeArea: true,
                backgroundColor: Colors.white, // Default is Colors.white.
                handleAndroidBackButtonPress: true, // Default is true.
                resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                stateManagement: true, // Default is true.
                hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                decoration: NavBarDecoration(
                  colorBehindNavBar: Colors.white,
                ),
                popAllScreensOnTapOfSelectedTab: true,
                popActionScreens: PopActionScreensType.all,
                itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle.style3,

              ),
              Visibility(
                visible: !snapshot.hasData ? false : snapshot.data!,
                child:  Container(
                  width: double.infinity,
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_none),
                      SizedBox(
                        width: 10,
                      ),
                      Text("New noise/motion has detected!",style: TextStyle(fontFamily: "semibold"),),
                      Spacer(),
                      Text("now",style: TextStyle(fontFamily: "regular"),),
                    ],
                  ),
                ),
              )
            ],
          )
        );
      }
    );
  }
}
