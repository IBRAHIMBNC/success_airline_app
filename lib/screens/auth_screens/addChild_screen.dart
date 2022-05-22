import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/controllers/auth_controller.dart';
import 'package:success_airline/controllers/child_controller.dart';
import 'package:success_airline/models/childModel.dart';
import 'package:success_airline/screens/home_screen.dart';

import '../../constants.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/smallText.dart';
import '../../widgets/textfeild2.dart';

import 'hearAbout_screen.dart';

class AddChildScreen extends StatefulWidget {
  Map<String, dynamic>? userDetails =
      Get.arguments == null ? null : Get.arguments as Map<String, dynamic>;

  AddChildScreen({Key? key}) : super(key: key);

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _key = GlobalKey<FormState>();
  bool isBoy = true;
  final dateCont = TextEditingController();
  bool isLoading = false;
  File? childImage;
  Map<String, dynamic> childDetails = {};

  void selectImage() async {
    final _imagePicker = ImagePicker();
    final xfile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      setState(() {
        childImage = File(xfile.path);
      });
      childDetails['image'] = childImage;
    }
  }

  void onSave() {
    if (!_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();
    if (childImage == null) {
      Get.closeAllSnackbars();
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 4),
        overlayColor: Colors.red,
        backgroundColor: Colors.red,
        title: 'Sign up failed',
        message: 'Please select profile image',
      ));
      return;
    }
    childDetails['gender'] = isBoy ? 'male' : 'female';
    widget.userDetails!['childDetails'] = childDetails;
    Get.to(() => HearAboutUScreen(), arguments: widget.userDetails);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    dateCont.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top - (3.h)),
                child: Column(children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            // size: 30,
                          ))),
                  if (widget.userDetails != null)
                    Lottie.asset('assets/json/addchildAnimation.json',
                        height: 20.h),
                  if (widget.userDetails == null)
                    GestureDetector(
                      onTap: selectImage,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: SmallText(
                              text: 'Children Details',
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            height: 23.h,
                            width: 23.h,
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/pngs/childAvater.png',
                                  height: 23.h,
                                  fit: BoxFit.fitHeight,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: childImage != null
                                        ? FileImage(childImage!)
                                        : null,
                                    radius: 7.5.h,
                                  ),
                                ),
                                Positioned(
                                  top: 4.h,
                                  right: 4.h,
                                  child: RoundedIconButton(
                                      icon: Icon(FontAwesomeIcons.camera)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.userDetails != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SmallText(
                          text: 'Add Child',
                          color: Colors.black,
                          size: 18,
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: selectImage,
                              child: CircleAvatar(
                                backgroundImage: childImage != null
                                    ? FileImage(childImage!)
                                    : null,
                                backgroundColor: kprimaryColor.withOpacity(0.2),
                                radius: 4.h,
                                child: childImage == null
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
                              text: 'Child Photo',
                              color: Colors.black,
                            )
                          ],
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Form(
                      key: _key,
                      child: Column(
                        children: [
                          CustomTextField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Child Name is empty';
                                }
                                return null;
                              },
                              onSave: (val) {
                                childDetails['name'] = val!.trim();
                              },
                              hintext: 'jason Born',
                              prefixIcon: FontAwesomeIcons.baby,
                              label: 'Child Name'),
                          SizedBox(
                            height: 2.h,
                          ),
                          DatePickerField(
                            onSave: (val) {
                              childDetails['DOB'] = val;
                            },
                            controller: dateCont,
                            label: 'Child DOB',
                            prefexIcon: FontAwesomeIcons.cakeCandles,
                            size: Size(90, 9),
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Please select child date of birth';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CustomTextField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Enter child Grade';
                                }
                                return null;
                              },
                              onSave: (val) {
                                childDetails['grade'] = val!.trim();
                              },
                              hintext: 'Elementary',
                              prefixIcon: FontAwesomeIcons.bookOpenReader,
                              label: 'Grade'),
                        ],
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  const SmallText(
                    text: 'Kid Gender',
                    color: Colors.black45,
                    size: 15,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBoy = true;
                            childDetails['gender'] = isBoy ? 'male' : 'female';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 25.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              border: !isBoy ? Border.all() : null,
                              borderRadius: BorderRadius.circular(15),
                              color: isBoy ? purpleColor : Colors.white),
                          child: SmallText(
                            color: isBoy ? Colors.white : Colors.black,
                            text: 'Boy',
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBoy = false;
                            childDetails['gender'] = isBoy ? 'male' : 'female';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 25.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              border: isBoy ? Border.all() : null,
                              borderRadius: BorderRadius.circular(15),
                              color: !isBoy ? purpleColor : Colors.white),
                          child: SmallText(
                            text: 'Girl',
                            size: 16,
                            color: isBoy ? Colors.black : Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        if (widget.userDetails != null)
                          RoundedButton(
                              onPressed: () {
                                widget.userDetails!.removeWhere(
                                    (key, value) => key == 'ChildDetails');
                                Get.to(() => HearAboutUScreen(),
                                    arguments: widget.userDetails);
                              },
                              textColor: Colors.black,
                              label: 'SKIP',
                              bgColor: Colors.black12,
                              size: const Size(40, 6)),
                        const Spacer(),
                        if (widget.userDetails != null)
                          RoundedButton(
                            onPressed: onSave,
                            label: 'NEXT',
                            size: const Size(40, 6),
                          ),
                      ],
                    ),
                  ),
                  if (widget.userDetails == null && !isLoading)
                    RoundedButton(
                      label: 'ADD CHILD',
                      onPressed: addNewChild,
                    ),
                  if (isLoading)
                    Container(
                      width: 90.w,
                      height: 6.5.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: kprimaryColor),
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                    ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addNewChild() async {
    if (_key.currentState!.validate()) {
      final AuthController auth = Get.find();
      if (childImage == null) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 4),
          overlayColor: Colors.red,
          backgroundColor: Colors.red,
          title: 'Child Picture',
          message: 'Please select child image',
        ));
        return;
      }

      _key.currentState!.save();
      setState(() {
        isLoading = true;
      });

      auth.uploadProfile(childImage!).then((url) {
        final ChildrenController cont = Get.find();
        final newChild = Child(
            id: '',
            name: childDetails['name'],
            DOB: childDetails['DOB'],
            grade: childDetails['grade'],
            isBoy: isBoy,
            photo: url);
        cont.addChild(newChild).then((value) {
          Get.back();
          Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 4),
            overlayColor: Colors.green,
            backgroundColor: Colors.green,
            title: 'Child Added',
            message: 'Child have been successfulky added',
          ));
        });
      });
    }
  }
}
