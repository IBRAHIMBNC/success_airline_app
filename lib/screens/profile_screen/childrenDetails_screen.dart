import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/controllers/auth_controller.dart';
import 'package:success_airline/controllers/child_controller.dart';
import 'package:success_airline/models/childModel.dart';
import 'package:success_airline/screens/auth_screens/addChild_screen.dart';
import 'package:success_airline/screens/home_screen.dart';
import 'package:success_airline/screens/profile_screen/editChildDetails_screen.dart';
import '../../constants.dart';
import '../../widgets/smallText.dart';
import 'components/profileImage.dart';

class ChildrenDetialScreen extends StatelessWidget {
  final AuthController auth = Get.find();

  ChildrenDetialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Child List',
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
        elevation: 0,
        leading: IconButton(
          icon: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(children: [
        GetBuilder<ChildrenController>(
            init: Get.put(ChildrenController()),
            builder: (controller) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  height: 75.h,
                  width: 90.w,
                  child: controller.children.isEmpty
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SmallText(
                                text: 'Add child ',
                                color: kprimaryColor,
                                size: 20,
                              ),
                              Icon(
                                Icons.add,
                                color: kprimaryColor,
                              )
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) => _ChildListCard(
                            child: controller.children[index],
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 1.h,
                          ),
                          itemCount: controller.children.length,
                        ),
                ),
              );
            }),
        GestureDetector(
          onTap: () {
            Get.to(() => AddChildScreen());
          },
          child: Container(
            alignment: Alignment.center,
            width: 90.w,
            height: 6.5.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: kprimaryColor)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Spacer(
                flex: 5,
              ),
              Icon(
                FontAwesomeIcons.plus,
                color: kprimaryColor,
                size: 3.h,
              ),
              Spacer(),
              SmallText(
                text: 'Add Child',
                size: 18,
                color: kprimaryColor,
              ),
              Spacer(
                flex: 5,
              ),
            ]),
          ),
        ),
      ]),
    );
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5),
      height: 14.h,
      width: 90.w,
      decoration: BoxDecoration(
          color: kprimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          width: 20.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleProfileImage(
                url: child.photo,
              ),
              SmallText(
                text: 'Photo',
                color: Colors.black45,
              )
            ],
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const SmallText(
                text: 'Name',
                color: Colors.black38,
              ),
              Spacer(),
              const SmallText(
                text: 'DOB',
                color: Colors.black38,
              ),
              Spacer(),
              const SmallText(
                text: 'Grade',
                color: Colors.black38,
              )
            ],
          ),
        ),
        SizedBox(
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
              Spacer(),
              SmallText(
                size: 13,
                text: child.grade,
                color: Colors.black,
              ),
            ],
          ),
        ),
        Spacer(),
        Column(
          children: [
            RoundedIconButton(
              onTap: () {
                Get.to(() => EditChildDetailScreen(
                      child: child,
                    ));
              },
              bgColor: kprimaryColor,
              icon: Icon(
                Icons.edit,
                size: 2.h,
                color: Colors.white,
              ),
            )
          ],
        )
      ]),
    );
  }
}
