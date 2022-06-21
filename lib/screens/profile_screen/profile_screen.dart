import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/controllers/child_controller.dart';
import 'package:success_airline/screens/auth_screens/referral_screen.dart';
import 'package:success_airline/screens/profile_screen/aboutUs_screen.dart';

import '../../constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/smallText.dart';
import 'childrenDetails_screen.dart';
import 'editProfile_Screen.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController auth = Get.find();
  final ChildrenController childrenController = Get.put(ChildrenController());
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: CustomPaint(
              size: Size(100.w, 105.h),
              painter: RPSCustomPainter(),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top + 1.h,
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
                height: 75.h,
                child: Column(children: [
                  SizedBox(
                    width: 21.5.h,
                    height: 22.h,
                    child: Stack(children: [
                      Image.asset(
                        'assets/pngs/profileAvater.png',
                        height: 25.h,
                        fit: BoxFit.fill,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 8.5.h,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              CachedNetworkImageProvider(auth.user!.profile),
                        ),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SmallText(
                    text: auth.user!.name,
                    color: Colors.black,
                    size: 18,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  RoundedButton(
                    image: Image.asset(
                      'assets/pngs/user.png',
                      height: 4.h,
                    ),
                    onPressed: () {
                      Get.to(() => const EditProfileScreen());
                    },
                    size: const Size(90, 7),
                    textColor: Colors.black,
                    bgColor: Colors.black.withOpacity(0.05),
                    label: 'My Account',
                    radius: 3,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: kprimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedButton(
                    image: Image.asset(
                      'assets/pngs/children.png',
                      height: 4.h,
                    ),
                    onPressed: () {
                      Get.to(() => ChildrenDetialScreen());
                    },
                    size: const Size(90, 7),
                    textColor: Colors.black,
                    bgColor: Colors.black.withOpacity(0.05),
                    label: 'Children Details',
                    radius: 3,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: kprimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedButton(
                    onPressed: () {
                      Get.to(() => ReferralScreen());
                    },
                    image: Image.asset(
                      'assets/pngs/refer.png',
                      height: 4.h,
                    ),
                    size: const Size(90, 7),
                    textColor: Colors.black,
                    bgColor: Colors.black.withOpacity(0.05),
                    label: 'Referral',
                    radius: 3,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: kprimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedButton(
                    onPressed: () {
                      Get.to(() => AboutUsScreen());
                    },
                    image: Image.asset(
                      'assets/pngs/info.png',
                      height: 4.h,
                    ),
                    size: const Size(90, 7),
                    textColor: Colors.black,
                    bgColor: Colors.black.withOpacity(0.05),
                    label: 'About us',
                    radius: 3,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: kprimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedButton(
                    onPressed: () {
                      auth.signOut();

                      Get.close(1);
                    },
                    image: Icon(
                      Icons.exit_to_app,
                      color: Colors.orange,
                      size: 4.h,
                    ),
                    size: const Size(90, 7),
                    textColor: Colors.black,
                    bgColor: Colors.black.withOpacity(0.05),
                    label: 'Log out',
                    radius: 3,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: kprimaryColor,
                    ),
                  )
                ]),
              )),
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(size.width * 1, 0);
    path_0.lineTo(size.width * 1, size.height * 0.1283722);
    path_0.cubicTo(
        size.width * 0.9974925,
        size.height * 0.1283722,
        size.width * 0.7413794,
        size.height * 0.07953020,
        size.width * 0.4919940,
        size.height * 0.1135756);
    path_0.cubicTo(
        size.width * 0.4184281,
        size.height * 0.1236201,
        size.width * 0.3607608,
        size.height * 0.1925172,
        size.width * 0.2937446,
        size.height * 0.2120617);
    path_0.cubicTo(size.width * 0.1359045, size.height * 0.2580827, 0,
        size.height * 0.2645536, 0, size.height * 0.2645536);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff0077ff).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
