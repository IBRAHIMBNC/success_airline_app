import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/bigTexT.dart';
import '../../widgets/smallText.dart';

import 'components/signupForm.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController auth = Get.find();
  File? image;

  void selectImage() async {
    final _imagePicker = ImagePicker();
    final xfile = await _imagePicker
        .pickImage(source: ImageSource.gallery, imageQuality: 60)
        .catchError((err) {
      Get.snackbar('Permission Denied', 'Go to Settings and allow photos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    });
    if (xfile != null) {
      setState(() {
        image = File(xfile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 40.h,
            child: Stack(children: [
              Positioned(
                  left: -3.h,
                  top: 0,
                  child: SvgPicture.asset(
                    'assets/svgs/Path .svg',
                    width: 55.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  )),
              Positioned(
                  top: 6.h,
                  left: 3.5.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              )),
                          SizedBox(
                            width: 4.w,
                          ),
                          const SmallText(
                            fontWeight: FontWeight.w500,
                            text: 'Hello,',
                            size: 18,
                          ),
                        ],
                      ),
                      const BigText(
                        text: 'Sign Up!',
                        size: 22,
                      )
                    ],
                  )),
              Positioned(
                bottom: 4.h,
                right: 4.w,
                child: Lottie.asset('assets/json/signUpAnimation.json',
                    height: 20.h),
              ),
              Positioned(
                  right: 5.w,
                  top: 5.h,
                  child: SvgPicture.asset('assets/svgs/logo.svg')),
              Positioned(
                bottom: 4.h,
                left: 5.w,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: selectImage,
                      child: CircleAvatar(
                        backgroundImage:
                            image != null ? FileImage(image!) : null,
                        backgroundColor: kprimaryColor.withOpacity(0.2),
                        radius: 4.h,
                        child: image == null
                            ? const Icon(
                                FontAwesomeIcons.camera,
                                color: Colors.black54,
                                size: 25,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const SmallText(
                      text: 'Photo',
                      color: Colors.black,
                    )
                  ],
                ),
              )
            ]),
          ),
          SignUpForm(
            image: image,
          )
        ])),
      ),
    );
  }
}
