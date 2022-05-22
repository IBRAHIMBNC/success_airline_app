import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/screens/admin_screens/categoryItemDetails_screen.dart';
import 'package:success_airline/screens/admin_screens/users_screen.dart';

import '../../constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/bigTexT.dart';
import '../../widgets/smallText.dart';
import '../home_screen.dart';
import '../profile_screen/profile_screen.dart';

class ContentScreen extends StatelessWidget {
  List<String> list = [
    'Life Skills',
    'Artist',
    'Entertainment',
    'Sports',
    'Farming',
    'Technology',
    'Engineer',
    'Food & Restaurants',
    'Drivers',
    'Sales',
    'Medical',
    'Music',
    'Lawyers',
    'Doctors',
    'Film Industry',
    'Teaching',
    'Finance',
    'Emergency',
    'Drivers',
    'Aerodynamics',
    'College Professors',
    'Oceanography',
    'Real Estate',
    'Construction',
    'Writers',
    'News',
    'Business Owners',
    'Financial literacy'
  ];
  final AuthController auth = Get.find();
  ContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    list.sort();
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, left: 20, right: 20),
            width: 100.w,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 1.h,
              ),
              const BigText(
                text: 'Success Airline',
                color: kprimaryColor,
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 4.w, right: 2.w),
                alignment: Alignment.center,
                height: 7.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kprimaryColor.withOpacity(0.1)),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 20),
                              border: InputBorder.none,
                              hintText: 'Search...')),
                    ),
                    RoundedIconButton(
                      onTap: () {
                        auth.signOut();
                        // auth.signOut();
                      },
                      icon: Icon(
                        Icons.search,
                        size: 4.h,
                        color: kprimaryColor,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              const SmallText(
                text: 'All categories',
                color: Colors.black,
                size: 18,
              ),
              SizedBox(
                height: 2.h,
              ),
              ListView.separated(
                padding: EdgeInsets.only(top: 0, bottom: 10.h),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 0.5.h),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Get.to(
                        () => CategoryItemDetailScreen(category: list[index]));
                  },
                  child: _AllCategoriesItemCard(
                    list: list,
                    index: index,
                  ),
                ),
                itemCount: list.length,
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class _AllCategoriesItemCard extends StatelessWidget {
  final int index;
  const _AllCategoriesItemCard({
    required this.index,
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      width: 90.w,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: index == 1 || index == 4
              ? EdgeInsets.zero
              : const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              SizedBox(
                  height: 10.h,
                  width: 10.w,
                  child: SvgPicture.asset('assets/svgs/alert.svg')),
              SizedBox(
                width: index == 1 || index == 4 ? 13.w : 8.w,
              ),
              SmallText(
                size: 16,
                text: list[index],
                color: Colors.black,
              ),
              const Spacer(),
              const RoundedIconButton(
                  icon: Icon(
                Icons.arrow_forward_ios,
                color: purpleColor,
              )),
              SizedBox(
                width: 3.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}
