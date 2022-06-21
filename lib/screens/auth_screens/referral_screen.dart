// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/svgs/logo.svg',
                        height: 8.h,
                      ),
                    ),
                    if (userDetails != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            referralKey.currentState!.onDone();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 20),
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Lottie.asset('assets/json/gift.json', height: 20.h),
                SizedBox(
                  height: 2.h,
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
                  key: referralKey,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
