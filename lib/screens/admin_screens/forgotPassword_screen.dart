// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/widgets/bigTexT.dart';
import 'package:success_airline/widgets/roundedButton.dart';
import 'package:success_airline/widgets/smallText.dart';
import 'package:success_airline/widgets/textfeild2.dart';

class ForgotPasswordScreen extends StatelessWidget {
  RxString email = ''.obs;
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
        title: BigText(
          text: 'Forgot Password',
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      body: Container(
          width: 100.w,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              SmallText(
                text: 'Enter your account email',
                size: 18,
                color: Colors.black,
              ),
              SizedBox(
                height: 2.h,
              ),
              CustomTextField(
                validator: (input) => input!.isValidEmail()
                    ? null
                    : "Please Enter valid email address.",
                onChanged: (value) {
                  email.value = value!;
                },
                alwaysValidate: true,
                prefixIcon: FontAwesomeIcons.solidEnvelope,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 1.h,
              ),
              Obx(
                () => RoundedButton(
                  label: 'Send reset link',
                  onPressed: !GetUtils.isEmail(email.value)
                      ? null
                      : () async {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.value)
                              .then((value) {
                            Get.back();
                            Get.showSnackbar(GetSnackBar(
                              duration: const Duration(seconds: 4),
                              overlayColor: Colors.green,
                              backgroundColor: Colors.green,
                              title: 'Verification email sent',
                              message: "Reset mail is sent to your email!",
                            ));
                          }).catchError((err) {
                            print(err);
                          });
                        },
                ),
              )
            ],
          )),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
