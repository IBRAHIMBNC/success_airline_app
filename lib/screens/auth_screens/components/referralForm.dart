import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/roundedButton.dart';
import '../../../widgets/smallText.dart';
import '../../../widgets/textfeild2.dart';
import '../../home_screen.dart';
import 'loading_screen.dart';

class ReferralForm extends StatefulWidget {
  final Map<String, dynamic>? userDetails;
  const ReferralForm({Key? key, required this.userDetails}) : super(key: key);

  @override
  State<ReferralForm> createState() => _ReferralFormState();
}

class _ReferralFormState extends State<ReferralForm> {
  final AuthController auth = Get.find();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? firstNameValidator(String? value) {
    if (value!.trim().isEmpty) return 'Enter first name';
    return null;
  }

  String? lastNameValidator(String? value) {
    if (value!.trim().isEmpty) return 'Enter Last name';
    return null;
  }

  String? emailValidator(String? value) {
    if (!GetUtils.isEmail(value!)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void onDone() async {
    Get.dialog(const ProgressScreen(), barrierDismissible: false);
    String name = widget.userDetails!['firstName'] +
        ' ' +
        widget.userDetails!['lastName'];
    String email = widget.userDetails!['email'];
    String password = widget.userDetails!['password'];

    await auth
        .signUp(name, email, password, widget.userDetails!)
        .then((value) => Get.close(6))
        .catchError((err) {
      print(err.runtimeType);
      String msg = err.toString();
      if (msg.contains('A network error')) {
        msg = 'Please check your internet connection';
      }
      if (msg.contains('email-already-in-use')) {
        msg = 'The email you entered is already exists';
      }
      Get.close(1);
      Get.dialog(
              CupertinoAlertDialog(
                title: const Text('Sign up failed'),
                content: Text(msg),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Get.offAll(() => HomeScreen());
                    },
                  )
                ],
              ),
              barrierDismissible: false)
          .then((value) => Get.close(5));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        const SmallText(
          size: 13,
          text: '1st Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: [
            CustomTextField(
                onSave: (val) {},
                validator: firstNameValidator,
                isSmall: true,
                size: const Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            const Spacer(),
            const CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '2nd Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '3rd Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '4rt Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '5th Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '6th Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '7th Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '8th Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '9th Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        const SmallText(
          size: 13,
          text: '10th Referral',
          color: kprimaryColor,
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: const [
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'First Name'),
            Spacer(),
            CustomTextField(
                isSmall: true,
                size: Size(42, 7),
                hintext: '',
                prefixIcon: FontAwesomeIcons.userLarge,
                label: 'Last Name')
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        const CustomTextField(
            size: Size(90, 7),
            hintext: '',
            prefixIcon: FontAwesomeIcons.solidEnvelope,
            label: 'Email'),
        SizedBox(
          height: 4.h,
        ),
        RoundedButton(
          label: 'DONE',
          onPressed: widget.userDetails != null ? onDone : null,
          // onPressed: () {
          //   Get.dialog(
          //       CupertinoAlertDialog(
          //         title: Text('Signup failed'),
          //         content: Text('msg'),
          //         actions: [
          //           CupertinoDialogAction(
          //             child: Text('Ok'),
          //             onPressed: () {
          //               Get.close(5);
          //             },
          //           )
          //         ],
          //       ),
          //       barrierDismissible: false);
          // },
        )
      ],
    ));
  }
}
