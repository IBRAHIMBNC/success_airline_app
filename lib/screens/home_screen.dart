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
  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    list.sort();
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
                                print('signout');
                                auth.signOut();
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
                        text: 'Continue Learning',
                        color: Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        height: 23.h,
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                _ContinueLearningCard(
                                  index: index,
                                ),
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 4.w,
                                ),
                            itemCount: list.length),
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
                            Get.to(
                                () => CategoryDetailScreen(title: list[index]));
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
      padding: const EdgeInsets.only(top: 10, bottom: 1),
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
                  height: index == 1 || index == 4 ? 13.h : 9.h,
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
