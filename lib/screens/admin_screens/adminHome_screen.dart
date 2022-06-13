import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/screens/admin_screens/contents_screen.dart';
import 'package:success_airline/screens/admin_screens/users_screen.dart';

import '../../constants.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final bottomNaviCont = CircularBottomNavigationController(0);
  List<Widget> screens = [ContentScreen(), UserScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: screens[bottomNaviCont.value!],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: CircularBottomNavigation(
            [
              TabItem(CupertinoIcons.doc_text, 'Contents', Colors.white,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16.sp)),
              TabItem(CupertinoIcons.person_3_fill, 'Users', Colors.white,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16.sp))
            ],
            selectedIconColor: kprimaryColor,
            normalIconColor: Colors.white,
            barBackgroundColor: kprimaryColor,
            barHeight: 9.h,
            iconsSize: 4.h,
            circleSize: 7.h,
            controller: bottomNaviCont,
            selectedCallback: (pos) {
              setState(() {
                bottomNaviCont.value = pos;
              });
            },
            circleStrokeWidth: 2,
          ),
        ));
  }
}
