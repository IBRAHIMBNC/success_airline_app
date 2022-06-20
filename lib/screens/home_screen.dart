// ignore_for_file: must_be_immutable

import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/controllers/lessons_controller.dart';
import 'package:success_airline/screens/categoryDetails_screen.dart';

import 'package:success_airline/screens/profile_screen/profile_screen.dart';
import '../../constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/smallText.dart';

import '../constants.dart';
import '../widgets/bigTexT.dart';
import '../widgets/smallText.dart';

_HomeScreenState? state;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() {
    state = _HomeScreenState();
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController auth = Get.find();
  final LessonsController lessoons = Get.put(LessonsController());
  bool isLoading = false;
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
    'Financial Literacy': 'assets/json/financial literacy.json'
  };
  int i = 0;
  @override
  void initState() {
    // if (auth.user != null)
    //   setState(() {
    //     isLoading = false;
    //   });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    allCategories = SplayTreeMap<String, dynamic>.from(
        allCategories, (a, b) => a.compareTo(b)).cast();

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 100.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const BigText(
                                  text: 'Success Airlines',
                                  color: kprimaryColor,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => ProfileScreen());
                                  },
                                  child: GetBuilder<AuthController>(
                                      builder: (controller) {
                                    if (controller.user != null) {
                                      return CircleAvatar(
                                        backgroundColor: Colors.grey.shade300,
                                        radius: 3.1.h,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                auth.user!.profile),
                                      );
                                    }
                                    return CircleAvatar(
                                      backgroundColor: kprimaryColor,
                                      radius: 3.1.h,
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
                                  Expanded(
                                    child: TextField(
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                        ),
                                        decoration: const InputDecoration(
                                            hintStyle: TextStyle(fontSize: 20),
                                            border: InputBorder.none,
                                            hintText: 'Search...')),
                                  ),
                                  RoundedIconButton(
                                    radius: 5,
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
                                height: 24.h,
                                child: GetBuilder<AuthController>(
                                  builder: (controller) =>
                                      GetBuilder<LessonsController>(
                                    builder: (cont) => FutureBuilder(
                                      future: cont.fetchContinueCategory(),
                                      builder: ((context,
                                          AsyncSnapshot<
                                                  List<Map<String, dynamic>>>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (snapshot.data == null ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                            child: Lottie.asset(
                                              'assets/json/wait_doll.json',
                                            ),
                                          );
                                        }

                                        final list = snapshot.data;
                                        return ListView.separated(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder:
                                                (context, index) => SizedBox(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.to(() => CategoryDetailScreen(
                                                              title:
                                                                  list![index]
                                                                      ['name'],
                                                              image: allCategories[
                                                                  list[index][
                                                                      'name']]!));
                                                        },
                                                        child:
                                                            _ContinueLearningCard(
                                                          image: allCategories[
                                                              list![index]
                                                                  ['name']]!,
                                                          category: list[index]
                                                              ['name'],
                                                        ),
                                                      ),
                                                    ),
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                                      width: 4.w,
                                                    ),
                                            itemCount:
                                                list == null ? 0 : list.length);
                                      }),
                                    ),
                                  ),
                                )),
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
                                        title:
                                            allCategories.keys.toList()[index],
                                        image: allCategories.values
                                            .toList()[index],
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
  final String image;
  final String category;

  const _ContinueLearningCard({
    Key? key,
    required this.image,
    required this.category,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 0),
      child: SizedBox(
        height: 10.h,
        width: 30.w,
        child: Stack(clipBehavior: Clip.hardEdge, children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h),
              alignment: Alignment.center,
              height: 20.h,
              width: 40.w,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ],
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Column(children: [
                if (image.contains('.json'))
                  Padding(
                    padding: EdgeInsets.only(
                        left: category.toLowerCase() == 'doctors' ? 0 : 2.w),
                    child: SizedBox(
                      height: category.toLowerCase() == 'doctors' ? 7.h : 12.h,
                      width: 23.w,
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
                  text: category,
                  color: Colors.black,
                  size: 14,
                ),
                const Spacer(
                  flex: 4,
                )
              ]),
            ),
          ),
          Positioned(
              bottom: 0.h,
              right: 11.w,
              child: RoundedIconButton(
                radius: 4,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: purpleColor,
                  size: 3.h,
                ),
              ))
        ]),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final Icon icon;
  final Function()? onTap;
  final Color bgColor;
  final double radius;
  const RoundedIconButton({
    Key? key,
    required this.icon,
    this.onTap,
    this.bgColor = Colors.white,
    this.radius = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: radius.h,
        width: radius.h,
        padding: EdgeInsets.all(0.2.h),
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
