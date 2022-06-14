import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/controllers/child_controller.dart';

import '../../constants.dart';
import '../../models/childModel.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/smallText.dart';
import '../../widgets/textfeild2.dart';
import '../home_screen.dart';

class EditChildDetailScreen extends StatefulWidget {
  final Child child;
  const EditChildDetailScreen({Key? key, required this.child})
      : super(key: key);

  @override
  State<EditChildDetailScreen> createState() => _EditChildDetailScreenState();
}

class _EditChildDetailScreenState extends State<EditChildDetailScreen> {
  File? childImage;
  bool isBoy = true;
  bool isLoading = false;
  final dateCont = TextEditingController();
  final nameCont = TextEditingController();
  final gradeCont = TextEditingController();
  final _key = GlobalKey<FormState>();
  String imageUrl = '';

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
        childImage = File(xfile.path);
      });
    }
  }

  @override
  void initState() {
    dateCont.text = widget.child.DOB;
    nameCont.text = widget.child.name;
    gradeCont.text = widget.child.grade;
    imageUrl = widget.child.photo;

    isBoy = widget.child.isBoy;

    super.initState();
  }

  @override
  void dispose() {
    dateCont.dispose();
    nameCont.dispose();
    gradeCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            width: 100.w,
            child: Padding(
              padding: EdgeInsets.only(top: 3.h),
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
                                    : CachedNetworkImageProvider(imageUrl)
                                        as ImageProvider<Object>?,
                                radius: 7.5.h,
                              ),
                            ),
                            Positioned(
                              top: 4.h,
                              right: 4.5.h,
                              child: RoundedIconButton(
                                  icon: Icon(
                                FontAwesomeIcons.camera,
                                size: 2.h,
                              )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Form(
                    key: _key,
                    child: Column(
                      children: [
                        CustomTextField(
                            controller: nameCont,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Child Name is empty';
                              }
                              return null;
                            },
                            hintext: '',
                            prefixIcon: FontAwesomeIcons.baby,
                            label: 'Child Name'),
                        SizedBox(
                          height: 1.h,
                        ),
                        DatePickerField(
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
                          height: 3.h,
                        ),
                        CustomTextField(
                            controller: gradeCont,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Enter child Grade';
                              }
                              return null;
                            },
                            onSave: (val) {},
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
                if (!isLoading)
                  RoundedButton(
                    label: 'Update Profile',
                    onPressed: updateProfile,
                  ),
                if (isLoading)
                  Container(
                    width: 90.w,
                    height: 6.5.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
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
    );
  }

  updateProfile() {
    final ChildrenController cont = Get.find();
    if (childImage != null) {
      setState(() {
        isLoading = true;
      });
      cont.auth.uploadProfile(childImage!).then((url) {
        final newData = Child(
            id: widget.child.id,
            name: nameCont.text,
            DOB: dateCont.text,
            grade: gradeCont.text,
            isBoy: isBoy,
            photo: url);
        cont.updateProfile(newData);
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Profile Updated', 'Child profile Updated',
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white);
      });
    } else {
      final newData = Child(
          id: widget.child.id,
          name: nameCont.text,
          DOB: dateCont.text,
          grade: gradeCont.text,
          isBoy: isBoy,
          photo: imageUrl);
      cont.updateProfile(newData).then((value) => Get.snackbar(
          'Profile Updated', 'Child profile Updated',
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white));
    }
  }
}
