// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';

import '../../widgets/bigTexT.dart';
import '../../widgets/roundedButton.dart';
import 'childrenCount_screen.dart';

enum AboutUs {
  club_house,
  reffered_by_a_friend,
  got_our_email,
  twitter,
  facebook,
  instagram
}

class HearAboutUScreen extends StatefulWidget {
  final userDetails = Get.arguments as Map<String, dynamic>;
  HearAboutUScreen({Key? key}) : super(key: key);

  @override
  State<HearAboutUScreen> createState() => _HearAboutUScreenState();
}

class _HearAboutUScreenState extends State<HearAboutUScreen> {
  AboutUs? about;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
        title: const BigText(
          text: 'Parent Survey',
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 89.h,
          width: 100.w,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Lottie.asset('assets/json/socialMedia.json',
                height: 18.h, fit: BoxFit.cover),
            const BigText(
              fontWeight: FontWeight.normal,
              size: 20,
              text: 'How did you hear\nabout us ?',
              color: Colors.black,
            ),
            SizedBox(
              height: 2.h,
            ),
            RoundedButton(
              size: Size(90, 6.5),
              onPressed: () {
                setState(() {
                  about = AboutUs.club_house;
                });
              },
              radius: 2,
              label: 'Club House',
              bgColor: about == AboutUs.club_house ? purpleColor : Colors.white,
              borderLess: about == AboutUs.club_house ? true : false,
              textColor:
                  about == AboutUs.club_house ? Colors.white : Colors.black,
            ),
            SizedBox(height: 2.h),
            RoundedButton(
              size: Size(90, 6.5),
              onPressed: () {
                setState(() {
                  about = AboutUs.reffered_by_a_friend;
                });
              },
              radius: 2,
              label: 'Referred by a Friend',
              bgColor: about == AboutUs.reffered_by_a_friend
                  ? purpleColor
                  : Colors.white,
              borderLess: about == AboutUs.reffered_by_a_friend ? true : false,
              textColor: about == AboutUs.reffered_by_a_friend
                  ? Colors.white
                  : Colors.black,
            ),
            SizedBox(height: 2.h),
            RoundedButton(
              size: Size(90, 6.5),
              onPressed: () {
                setState(() {
                  about = AboutUs.got_our_email;
                });
              },
              radius: 2,
              label: 'Got our Email',
              bgColor:
                  about == AboutUs.got_our_email ? purpleColor : Colors.white,
              borderLess: about == AboutUs.got_our_email ? true : false,
              textColor:
                  about == AboutUs.got_our_email ? Colors.white : Colors.black,
            ),
            SizedBox(height: 2.h),
            RoundedButton(
              size: Size(90, 6.5),
              onPressed: () {
                setState(() {
                  about = AboutUs.twitter;
                });
              },
              radius: 2,
              label: 'Twitter',
              bgColor: about == AboutUs.twitter ? purpleColor : Colors.white,
              borderLess: about == AboutUs.twitter ? true : false,
              textColor: about == AboutUs.twitter ? Colors.white : Colors.black,
            ),
            SizedBox(height: 2.h),
            RoundedButton(
              size: Size(90, 6.5),
              onPressed: () {
                setState(() {
                  about = AboutUs.facebook;
                });
              },
              radius: 2,
              label: 'Facebook',
              bgColor: about == AboutUs.facebook ? purpleColor : Colors.white,
              borderLess: about == AboutUs.facebook ? true : false,
              textColor:
                  about == AboutUs.facebook ? Colors.white : Colors.black,
            ),
            SizedBox(height: 2.h),
            RoundedButton(
              size: Size(90, 6.5),
              onPressed: () {
                setState(() {
                  about = AboutUs.instagram;
                });
              },
              radius: 2,
              label: 'Instagram',
              bgColor: about == AboutUs.instagram ? purpleColor : Colors.white,
              borderLess: about == AboutUs.instagram ? true : false,
              textColor:
                  about == AboutUs.instagram ? Colors.white : Colors.black,
            ),
            SizedBox(height: 2.h),
            RoundedButton(
              label: 'NEXT',
              onPressed: () {
                print(about);
                if (about == null) return;
                widget.userDetails['hearAboutUs'] = about!.name;
                Get.to(() => ChildrenCountScreen(),
                    arguments: widget.userDetails);
              },
            )
          ]),
        ),
      ),
    );
  }
}
