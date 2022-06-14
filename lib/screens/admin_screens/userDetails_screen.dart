import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/controllers/child_controller.dart';
import 'package:success_airline/models/appuser.dart';
import 'package:success_airline/widgets/smallText.dart';

import '../../constants.dart';
import '../../models/childModel.dart';
import '../profile_screen/components/profileImage.dart';
import '../profile_screen/profile_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final AppUser user;
  final childCont = Get.put(ChildrenController());

  UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 35.h,
          child: Stack(children: [
            Positioned(
              top: 0,
              child: CustomPaint(
                size: Size(100.w, 105.h),
                painter: RPSCustomPainter(),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).padding.top + (1.h),
                left: 5.w,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                )),
            Positioned(
              top: 5.h,
              child: SizedBox(
                width: 100.w,
                height: 31.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 22.h,
                      height: 22.h,
                      child: Stack(children: [
                        Image.asset(
                          'assets/pngs/profileAvater.png',
                          height: 22.h,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 9.h,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                CachedNetworkImageProvider(user.profile),
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SmallText(
                      text: user.name,
                      size: 18,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
        SmallText(
          text: user.email!,
          size: 16,
          color: Colors.black,
        ),
        SizedBox(
          height: 3.h,
        ),
        const SmallText(
          text: 'Children',
          size: 16,
          color: Colors.black54,
        ),
        SizedBox(height: 2.h),
        Container(
            constraints: BoxConstraints(
              minWidth: 100.w,
              // minHeight: 4.h,
              maxHeight: 27.h,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: kprimaryColor.withOpacity(0.05)),
            child: FutureBuilder(
                future: childCont.fetchData(id: user.id),
                builder: (context, AsyncSnapshot<List<Child>> snapshot) {
                  List<Child> children;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        radius: 2.h,
                      ),
                    );
                  }
                  if (snapshot.data == null) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: const SmallText(
                        text: 'No data',
                        color: Colors.black,
                      ),
                    );
                  }
                  children = snapshot.data!;

                  return ListView.separated(
                      padding: EdgeInsets.only(top: 5, left: 4.w, right: 4.w),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          _ChildListCard(child: children[index]),
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 2,
                            color: kprimaryColor,
                          ),
                      itemCount: children.length);
                })),
        SizedBox(
          height: 2.h,
        ),
        const SmallText(
          text: 'Paerent Survey',
          color: Colors.black45,
          size: 16,
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
          width: 100.w,
          height: 25.h,
          decoration: BoxDecoration(
              color: kprimaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(35)),
          child: Column(children: [
            const SmallText(
              text: 'How did you hear about us?',
              color: Colors.black,
              size: 14,
            ),
            SizedBox(height: 1.h),
            Row(children: [
              const Spacer(
                flex: 6,
              ),
              const SmallText(
                text: 'Answer:',
                size: 16,
                color: Colors.black54,
              ),
              const Spacer(),
              SmallText(
                text: user.hearAboutUs!.replaceAll('_', ' '),
                size: 14,
                color: Colors.black,
              ),
              const Spacer(
                flex: 6,
              )
            ]),
            SizedBox(height: 2.h),
            const SmallText(
              text: 'How many children do you have?',
              color: Colors.black,
              size: 14,
            ),
            SizedBox(height: 2.h),
            Container(
              height: 7.h,
              width: 90.w,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SmallText(
                              text: 'Children:',
                              size: 16,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            SmallText(
                              text: user.children!,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 2,
                        color: kprimaryColor,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SmallText(
                              text: 'Ages:',
                              size: 16,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            SmallText(
                              text: user.childrenAges!
                                      .split('_')[0]
                                      .substring(3) +
                                  '-' +
                                  user.childrenAges!.split('_')[1],
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 3.h,
        ),
        Container(
          height: 24.h,
          width: 100.w,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: kprimaryColor.withOpacity(0.05)),
          child: Row(children: [
            Expanded(
              child: Column(
                children: [
                  const SmallText(
                    text: 'Home Address',
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText(
                          text: 'Home:',
                          color: Colors.black45,
                        ),
                        Expanded(
                            child: SmallText(
                          color: Colors.black,
                          text: user.homeAddress['home']!,
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText(
                          text: 'City:',
                          color: Colors.black45,
                        ),
                        Expanded(
                            child: SmallText(
                          color: Colors.black,
                          text: user.homeAddress['city']!,
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText(
                          text: 'state:',
                          color: Colors.black45,
                        ),
                        Expanded(
                            child: SmallText(
                          color: Colors.black,
                          text: user.homeAddress['state']!,
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SmallText(
                          text: 'Zip Code:',
                          color: Colors.black45,
                        ),
                        Expanded(
                            child: SmallText(
                          color: Colors.black,
                          text: user.homeAddress['zipCode']!,
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: kprimaryColor,
              endIndent: 0.5.h,
              indent: 0.5.h,
              thickness: 2,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  children: [
                    const SmallText(
                      text: 'Home Address',
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SmallText(
                            text: 'Home:',
                            color: Colors.black45,
                          ),
                          Expanded(
                              child: SmallText(
                            color: Colors.black,
                            text: user.homeAddress['home']!,
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SmallText(
                            text: 'City:',
                            color: Colors.black45,
                          ),
                          Expanded(
                              child: SmallText(
                            color: Colors.black,
                            text: user.homeAddress['city']!,
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SmallText(
                            text: 'state:',
                            color: Colors.black45,
                          ),
                          Expanded(
                              child: SmallText(
                            color: Colors.black,
                            text: user.homeAddress['state']!,
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SmallText(
                            text: 'Zip Code:',
                            color: Colors.black45,
                          ),
                          Expanded(
                              child: SmallText(
                            color: Colors.black,
                            text: user.homeAddress['zipCode']!,
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 5.h,
        )
      ]),
    ));
  }
}

class _ChildListCard extends StatelessWidget {
  final Child child;
  const _ChildListCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      width: 90.w,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          width: 20.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleProfileImage(
                url: child.photo,
              ),
              const SmallText(
                text: 'Photo',
                color: Colors.black45,
              )
            ],
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SmallText(
                text: 'Name',
                color: Colors.black38,
              ),
              Spacer(),
              SmallText(
                text: 'DOB',
                color: Colors.black38,
              ),
              Spacer(),
              SmallText(
                text: 'Grade',
                color: Colors.black38,
              )
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmallText(
                size: 13,
                text: child.name,
                color: Colors.black,
              ),
              const Spacer(),
              SmallText(
                size: 13,
                text: child.DOB,
                color: Colors.black,
              ),
              const Spacer(),
              SmallText(
                size: 13,
                text: child.grade,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const Spacer(),
      ]),
    );
  }
}
