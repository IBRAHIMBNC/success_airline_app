import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/bigTexT.dart';
import 'components/referralForm.dart';

class ReferralScreen extends StatelessWidget {
  final userDetails =
      Get.arguments != null ? Get.arguments as Map<String, dynamic> : null;
  ReferralScreen({Key? key}) : super(key: key);
  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 100.h,
            width: 90.w,
            child: SingleChildScrollView(
              child: Column(children: [
                SvgPicture.asset(
                  'assets/svgs/logo.svg',
                  height: 10.h,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Image.asset(
                  'assets/pngs/refer.png',
                  height: 5.h,
                ),
                SizedBox(
                  height: 15.h,
                ),
                const BigText(
                  fontWeight: FontWeight.normal,
                  size: 22,
                  text:
                      'Refer 10 people for your \n chance toy receive a\n special gift',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 4.h,
                ),
                ReferralForm(
                  userDetails: userDetails,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
