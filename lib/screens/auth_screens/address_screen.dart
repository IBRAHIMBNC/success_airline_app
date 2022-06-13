import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/screens/auth_screens/signUp_screen.dart';
import 'package:success_airline/widgets/roundedButton.dart';

import '../../widgets/bigTexT.dart';
import '../../widgets/smallText.dart';
import '../../widgets/textfeild2.dart';
import 'addChild_screen.dart';

class AddressScreen extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  final userDetails = Get.arguments as Map<String, dynamic>;
  AddressScreen({Key? key}) : super(key: key);
  void onSave() async {
    print(userDetails);
    if (!_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();

    userDetails['homeAddress'] = homeAddress;
    userDetails['mailingAddress'] = mailingAddress;
    print(userDetails);
    Get.to(() => AddChildScreen(), arguments: userDetails);
  }

  Map<String, String> mailingAddress = {};
  Map<String, String> homeAddress = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20.h,
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
                    right: 5.w,
                    top: 5.h,
                    child: SvgPicture.asset('assets/svgs/logo.svg')),
              ]),
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  const SmallText(
                    size: 14,
                    text: 'Home Address',
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      onSave: (val) {
                        homeAddress['home'] = val!;
                      },
                      hintext: '',
                      prefixIcon: FontAwesomeIcons.house,
                      label: 'House Address'),
                  CustomTextField(
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'This field must not be empty';
                      }
                      return null;
                    },
                    onSave: (val) {
                      homeAddress['city'] = val!;
                    },
                    hintext: '',
                    prefixIcon: FontAwesomeIcons.city,
                    label: 'City',
                  ),
                  CustomTextField(
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      onSave: (val) {
                        homeAddress['state'] = val!;
                      },
                      hintext: '',
                      prefixIcon: FontAwesomeIcons.schoolFlag,
                      label: 'State'),
                  CustomTextField(
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      onSave: (val) {
                        homeAddress['zipCode'] = val!;
                      },
                      hintext: '',
                      prefixIcon: FontAwesomeIcons.mapPin,
                      label: 'Zip Code'),
                  SizedBox(
                    height: 2.h,
                  ),
                  const SmallText(
                    size: 14,
                    text: 'Mailing Address',
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      onSave: (val) {
                        mailingAddress['home'] = val!;
                      },
                      hintext: '',
                      prefixIcon: FontAwesomeIcons.house,
                      label: 'House Address'),
                  CustomTextField(
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'This field must not be empty';
                      }
                      return null;
                    },
                    onSave: (val) {
                      mailingAddress['city'] = val!;
                    },
                    hintext: '',
                    prefixIcon: Icons.apartment,
                    label: 'City',
                  ),
                  CustomTextField(
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      onSave: (val) {
                        mailingAddress['state'] = val!;
                      },
                      hintext: '',
                      prefixIcon: FontAwesomeIcons.schoolFlag,
                      label: 'State'),
                  CustomTextField(
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'This field must not be empty';
                        }
                        return null;
                      },
                      onSave: (val) {
                        mailingAddress['zipCode'] = val!;
                      },
                      hintext: '',
                      prefixIcon: FontAwesomeIcons.mapPin,
                      label: 'Zip Code'),
                ],
              ),
            ),
            RoundedButton(
              label: 'NEXT',
              onPressed: onSave,
            ),
            SizedBox(
              height: 3.h,
            )
          ]),
        ),
      ),
    );
  }
}
