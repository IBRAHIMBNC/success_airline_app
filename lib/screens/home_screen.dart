import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/screens/categoryDetails_screen.dart';

import 'package:success_airline/screens/profile_screen/profile_screen.dart';
import '../../constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/smallText.dart';

import '../constants.dart';
import '../widgets/bigTexT.dart';
import '../widgets/smallText.dart';

class HomeScreen extends StatelessWidget {
  final AuthController auth = Get.find();
  // List<Map<String, dynamic>> list = [
  //   {
  //     'title': 'Aerodynamics',
  //     'image': SvgPicture.asset('assets/svgs/helmet.svg')
  //   },
  //   {
  //     'title': 'Business owners',
  //     'image': Lottie.asset('assets/json/meeting.json', fit: BoxFit.cover)
  //   },
  //   {
  //     'title': 'College Professor',
  //     'image': SvgPicture.asset('assets/svgs/alert.svg')
  //   },
  //   {
  //     'title': 'Construction',
  //     'image': SvgPicture.asset('assets/svgs/helmet.svg')
  //   },
  //   {
  //     'title': 'Doctors',
  //     'image': Padding(
  //       padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
  //       child: Lottie.asset('assets/json/doctor.json', fit: BoxFit.cover),
  //     )
  //   },
  //   {'title': 'Drivers', 'image': SvgPicture.asset('assets/svgs/alert.svg')},
  //   {'title': 'Emergency', 'image': SvgPicture.asset('assets/svgs/alert.svg')},
  //   {
  //     'title': 'Life Skills',
  //     'image': SvgPicture.asset('assets/svgs/alert.svg')
  //   },
  //   {'title': 'Artist', 'image': SvgPicture.asset('assets/svgs/alert.svg')},
  //   {
  //     'title': 'Entertainment',
  //     'image': SvgPicture.asset('assets/svgs/alert.svg')
  //   },
  //   {'title': 'Sports', 'image': SvgPicture.asset('assets/svgs/alert.svg')},
  //   {'title': 'arming', 'image': SvgPicture.asset('assets/svgs/alert.svg')}
  // ];

  Map<String, String> allCategories = {
    'Doctors': 'assets/json/doctor.json',
    'Life Skills': 'assets/json/life skills.json',
    'Artist': 'assets/json/artist.json',
    'Entertainment': 'assets/json/entertainment.json',
    'Sports': 'assets/json/sports.json',
    'Farming': 'assets/json/farming.json',
    'Technology': 'assets/json/technology.json',
    'Engineer': 'assets/json/engineer.json',
    'Food & Restaurants': 'assets/json/food and restaurant.json',
    'Sales': 'assets/json/sales.json',
    'Medical': 'assets/json/medical.json',
    'Music': 'assets/json/music.json',
    'Lawyers': 'assets/pngs/lawyer.png',
    'Film Industry': 'assets/json/film industry.json',
    'Teaching': 'assets/json/teaching.json',
    'Finance': 'assets/json/finance.json',
    'Emergency': 'assets/json/emergency.json',
    'Drivers': 'assets/json/driver.json',
    'Aerodynamics': 'assets/json/aerodynamics.json',
    'College Professors': 'assets/pngs/college professor.png',
    'Oceanography': 'assets/json/oceanographi.json',
    'Real Estate': 'assets/json/real estate.json',
    'Construction': 'assets/json/construction.json',
    'Writers': 'assets/json/writers.json',
    'News': 'assets/json/news.json',
    'Business Owners': 'assets/json/business owner.json',
    'Financial literacy': 'assets/json/financial literacy.json'
  };
  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    allCategories = SplayTreeMap<String, dynamic>.from(
        allCategories, (a, b) => a.compareTo(b)).cast();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: GetBuilder<AuthController>(
              builder: (controller) => SizedBox(
                width: 90.w,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const BigText(
                            text: 'Success Airline',
                            color: kprimaryColor,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ProfileScreen());
                            },
                            child: GetBuilder<AuthController>(
                                builder: (controller) {
                              if (!controller.initialized) {
                                return CircleAvatar(
                                  backgroundColor: kprimaryColor,
                                  radius: 3.1.h,
                                  backgroundImage: auth.user == null
                                      ? null
                                      : CachedNetworkImageProvider(
                                          auth.user!.profile),
                                );
                              }
                              return CircleAvatar(
                                backgroundColor: kprimaryColor,
                                radius: 3.1.h,
                                backgroundImage: auth.user == null
                                    ? null
                                    : CachedNetworkImageProvider(
                                        auth.user!.profile),
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(left: 4.w, right: 2.w),
                      //   alignment: Alignment.center,
                      //   height: 7.h,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(15),
                      //       color: kprimaryColor.withOpacity(0.1)),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextField(
                      //             style: TextStyle(
                      //               fontSize: 16.sp,
                      //             ),
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(fontSize: 20),
                      //                 border: InputBorder.none,
                      //                 hintText: 'Search...')),
                      //       ),
                      //       RoundedIconButton(
                      //         onTap: () {
                      //           print('signout');
                      //           auth.signOut();
                      //         },
                      //         icon: Icon(
                      //           Icons.search,
                      //           size: 4.h,
                      //           color: kprimaryColor,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 2.h,
                      ),
                      const SmallText(
                        text: 'Continue Learning',
                        color: Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        height: 23.h,
                        child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => SizedBox(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: _ContinueLearningCard(
                                          index: index,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 4.w,
                                ),
                            itemCount: allCategories.length),
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
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 0.5.h),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Get.to(() => CategoryDetailScreen(
                                  title: allCategories.keys.toList()[index],
                                  image: allCategories.values.toList()[index],
                                ));
                          },
                          child: _AllCategoriesItemCard(
                            category: allCategories.keys.toList()[index],
                            image: allCategories.values.toList()[index],
                          ),
                        ),
                        itemCount: allCategories.length,
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllCategoriesItemCard extends StatelessWidget {
  final String category;
  final String image;
  _AllCategoriesItemCard({
    Key? key,
    required this.category,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      width: 90.w,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              if (image.contains('.json'))
                Padding(
                  padding: EdgeInsets.only(
                      left: category.toLowerCase() == 'doctors' ? 0 : 2.w),
                  child: SizedBox(
                    height: category.toLowerCase() == 'doctors' ? 7.h : 9.h,
                    width: 20.w,
                    child: Lottie.asset(
                      image,
                      fit: category.toLowerCase() == 'doctors'
                          ? BoxFit.cover
                          : BoxFit.contain,
                    ),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.all(2.h),
                  child: SizedBox(
                    height: 6.h,
                    width: 6.h,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Spacer(),
              SmallText(
                size: 16,
                text: category,
                color: Colors.black,
              ),
              Spacer(
                flex: 2,
              ),
              const RoundedIconButton(
                  icon: Icon(
                Icons.arrow_forward_ios,
                color: purpleColor,
              )),
              SizedBox(
                width: 4.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  _ContinueLearningCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  List<Map<String, dynamic>> list = [
    {
      'title': 'Aerodynamics',
      'image': 'assets/svgs/helmet.svg',
    },
    {
      'title': 'Business owners',
      'image': 'assets/json/meeting.json',
    },
    {
      'title': 'College Professor',
      'image': 'assets/svgs/alert.svg',
    },
    {
      'title': 'Construction',
      'image': 'assets/svgs/helmet.svg',
    },
    {
      'title': 'Doctors',
      'image': 'assets/json/doctor.json',
    },
    {
      'title': 'Drivers',
      'image': 'assets/svgs/alert.svg',
    },
    {
      'title': 'Emergency',
      'image': 'assets/svgs/alert.svg',
    }
  ];
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 0),
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.only(
                left: 4.w,
                right: 4.w,
                top: index == 1 || index == 4 ? 1.h : 3.h),
            alignment: Alignment.center,
            height: 20.h,
            width: 40.w,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
              ],
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: Column(children: [
              SizedBox(
                  height: index == 1 || index == 5 ? 13.h : 9.h,
                  width: 30.w,
                  child: index == 1 || index == 4
                      ? Lottie.asset(list[index]['image'])
                      : SvgPicture.asset(list[index]['image'])),
              if (index != 1 && index != 4)
                SizedBox(
                  height: 2.h,
                ),
              SmallText(
                text: list[index]['title'],
                color: Colors.black,
                size: 12,
              )
            ]),
          ),
        ),
        Positioned(
            bottom: 0.4.h,
            right: 17.w,
            child: const RoundedIconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: purpleColor,
              ),
            ))
      ]),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final Icon icon;
  final Function()? onTap;
  final Color bgColor;
  const RoundedIconButton({
    Key? key,
    required this.icon,
    this.onTap,
    this.bgColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(0.7.h),
        child: icon,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
          ],
          shape: BoxShape.circle,
          color: bgColor,
        ),
      ),
    );
  }
}
