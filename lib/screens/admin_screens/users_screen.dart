import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/controllers/auth_controller.dart';
import 'package:success_airline/controllers/child_controller.dart';
import 'package:success_airline/models/appuser.dart';
import 'package:success_airline/screens/admin_screens/userDetails_screen.dart';
import 'package:success_airline/widgets/bigTexT.dart';
import 'package:success_airline/widgets/smallText.dart';

import '../home_screen.dart';

class UserScreen extends StatelessWidget {
  AuthController auth = Get.find();

  final searchCont = TextEditingController();
  Rx<String> searchKeyword = ''.obs;
  UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, right: 3.w, left: 3.w),
          width: 100.w,
          child: Container(
            width: 90.w,
            child: Column(children: [
              SizedBox(
                height: 1.h,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: BigText(
                  text: 'Success Airlines',
                  color: kprimaryColor,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 4.w, right: 2.w),
                alignment: Alignment.center,
                height: 8.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kprimaryColor.withOpacity(0.1)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          style: TextStyle(fontSize: 16.sp),
                          onChanged: (val) {
                            searchKeyword.value = val;
                          },
                          controller: searchCont,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(fontSize: 20),
                              border: InputBorder.none,
                              hintText: 'Search...')),
                    ),
                    RoundedIconButton(
                      radius: 6,
                      onTap: () {},
                      icon: Icon(
                        Icons.search,
                        size: 5.h,
                        color: kprimaryColor,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                  width: 90.w,
                  height: 80.h,
                  child: Obx(
                    () => FutureBuilder(
                        future: auth.fetchAllUsers(
                            searchKeyword: searchKeyword.value),
                        builder:
                            ((context, AsyncSnapshot<List<AppUser>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CupertinoActivityIndicator(
                                radius: 2.h,
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: SmallText(
                                text: 'No data',
                                color: Colors.black,
                              ),
                            );
                          }
                          List<AppUser> users = snapshot.data!;
                          return ListView.separated(
                            padding: EdgeInsets.only(top: 2.h, bottom: 9.h),
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Get.to(
                                    () => UserDetailScreen(user: users[index]));
                              },
                              child: _userCard(
                                user: users[index],
                              ),
                            ),
                            separatorBuilder: (context, index) => Divider(
                              color: purpleColor.withOpacity(0.5),
                              thickness: 2,
                            ),
                            itemCount: users.length,
                          );
                        })),
                  )),
            ]),
          ),
        ),
      )),
    );
  }
}

class _userCard extends StatelessWidget {
  final AppUser user;
  const _userCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      width: 90.w,
      child: Row(children: [
        SizedBox(
          width: 2.w,
        ),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black45)),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.profile),
            backgroundColor: Colors.transparent,
            radius: 3.h,
          ),
        ),
        const Spacer(),
        SmallText(
          text: user.name,
          color: Colors.black,
          size: 16,
        ),
        const Spacer(
          flex: 10,
        )
      ]),
    );
  }
}
