import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/screens/admin_screens/categoryItemDetails_screen.dart';

import '../../constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/bigTexT.dart';
import '../../widgets/smallText.dart';
import '../home_screen.dart';

class ContentScreen extends StatelessWidget {
  final Map<String, String> allCategories = {
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
  final AuthController auth = Get.find();
  ContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    allCategories.addAll(SplayTreeMap<String, dynamic>.from(
        allCategories, (a, b) => a.compareTo(b)).cast());
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, left: 3.w, right: 3.w),
            width: 100.w,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BigText(
                    text: 'Success Airlines',
                    color: kprimaryColor,
                  ),
                  RoundedIconButton(
                    onTap: () {
                      auth.signOut();
                    },
                    icon: Icon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.white,
                      size: 3.h,
                    ),
                    radius: 5,
                    bgColor: kprimaryColor,
                  )
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
              //       const Expanded(
              //         child: TextField(
              //             decoration: InputDecoration(
              //                 hintStyle: TextStyle(fontSize: 20),
              //                 border: InputBorder.none,
              //                 hintText: 'Search...')),
              //       ),
              //       RoundedIconButton(
              //         onTap: () {
              //           auth.signOut();
              //           // auth.signOut();
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
                    Get.to(() => AddCategoryItemDetailScreen(
                        image: allCategories.values.toList()[index],
                        category: allCategories.keys.toList()[index]));
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
    );
  }
}

class _AllCategoriesItemCard extends StatelessWidget {
  final String category;
  final String image;
  const _AllCategoriesItemCard({
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
              const Spacer(),
              SmallText(
                size: 16,
                text: category,
                color: Colors.black,
              ),
              const Spacer(
                flex: 2,
              ),
              RoundedIconButton(
                  radius: 4,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: purpleColor,
                    size: 3.h,
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
