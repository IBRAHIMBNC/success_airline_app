import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:success_airline/screens/profile_screen/profile_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/smallText.dart';
import '../auth_screens/components/signupForm.dart';
import '../home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController auth = Get.find();
  File? newImage;
  void selectImage() async {
    final _imagePicker = ImagePicker();
    final xfile = await _imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((err) {
      Get.snackbar('Permission Denied', 'Go to Settings and allow photos',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    });
    if (xfile != null) {
      setState(() {
        newImage = File(xfile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                width: 100.w,
                height: 37.h,
                child: Stack(
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
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        )),
                    Positioned(
                        top: 5.h,
                        child: SizedBox(
                          width: 100.w,
                          child: Column(children: [
                            GestureDetector(
                              onTap: () {
                                selectImage();
                              },
                              child: SizedBox(
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
                                      backgroundImage: newImage != null
                                          ? FileImage(newImage!)
                                          : CachedNetworkImageProvider(
                                                  auth.user!.profile)
                                              as ImageProvider<Object>,
                                    ),
                                  ),
                                  Positioned(
                                      top: 3.h,
                                      right: 3.h,
                                      child: RoundedIconButton(
                                        radius: 4,
                                        icon: Icon(
                                          FontAwesomeIcons.camera,
                                          size: 3.h,
                                        ),
                                      ))
                                ]),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            SmallText(
                              text: auth.user!.name,
                              color: Colors.black,
                              size: 18,
                            ),
                          ]),
                        )),
                  ],
                ),
              ),
              SignUpForm(
                image: newImage,
                userData: auth.user,
              )
            ],
          ),
        ),
      ),
    );
  }
}
