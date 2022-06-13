import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/screens/admin_screens/forgotPassword_screen.dart';
import 'package:success_airline/screens/auth_screens/addChild_screen.dart';
import 'package:success_airline/screens/auth_screens/signUp_screen.dart';
import 'package:success_airline/screens/home_screen.dart';
import '../../constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/bigTexT.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/smallText.dart';
import '../../widgets/textfeild2.dart';
import '../buyPremium.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 47.h,
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
                          left: 5.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SmallText(
                                fontWeight: FontWeight.w500,
                                text: 'Welcome Back,',
                                size: 16,
                              ),
                              BigText(
                                text: 'Log in!',
                                size: 22,
                              )
                            ],
                          )),
                      Positioned(
                        bottom: 2.h,
                        right: 25.w,
                        child: SvgPicture.asset(
                          'assets/svgs/Feed-amico.svg',
                          width: 50.w,
                        ),
                      ),
                      Positioned(
                          right: 4.w,
                          top: 5.h,
                          child: SvgPicture.asset('assets/svgs/logo.svg'))
                    ]),
                  ),
                  const LoginForm(),
                ],
              ),
            ),
          ]),
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLoading = false;
  final AuthController auth = Get.find();
  String email = '';
  String password = '';
  final _key = GlobalKey<FormState>();

  void onSave() {
    FocusScope.of(context).unfocus();
    if (_key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _key.currentState!.save();
      auth.signIn(email, password).catchError((err) {
        String msg = err.toString();
        if (msg.contains('user-not-found')) {
          msg = 'Could not find any user with this email';
        }
        if (msg.contains('wrong-password')) {
          msg = 'The password you enter is incorrect';
        }
        if (msg.contains('A network error')) {
          msg = 'Please check your internet connection';
        }
        Get.closeAllSnackbars();
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 4),
          overlayColor: Colors.red,
          backgroundColor: Colors.red,
          title: 'Login failed',
          message: msg,
        ));
      }).then((value) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: Column(
          children: [
            CustomTextField(
              validator: (val) {
                if (!GetUtils.isEmail(val.toString())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSave: (val) {
                email = val!;
              },
              label: 'Email',
              hintext: '',
              prefixIcon: FontAwesomeIcons.solidEnvelope,
            ),
            // SizedBox(height: 2.h),
            CustomTextField(
              onSave: (val) {
                password = val!;
              },
              label: 'Password',
              hintext: '●●●●●●●●',
              prefixIcon: Icons.lock,
              isPassword: true,
            ),

            InkWell(
              onTap: () {
                Get.to(() => ForgotPasswordScreen());
              },
              child: const SmallText(
                text: 'Forgot Password?',
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            RoundedButton(
              isLoading: isLoading,
              onPressed: onSave,
              label: 'LOGIN',
            ),
            SizedBox(
              height: 4.h,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SmallText(
                size: 14,
                text: 'Create New Account? ',
                color: Colors.black,
              ),
              GestureDetector(
                onTap: () {
                  // Get.to(() => PremiumPlanScreen());
                  // Get.to(() => AddChildScreen());
                  Get.to(() => const SignUpScreen());
                },
                child: const BigText(
                  size: 14,
                  text: 'SIGN UP',
                  color: kprimaryColor,
                ),
              )
            ])
          ],
        ));
  }
}
