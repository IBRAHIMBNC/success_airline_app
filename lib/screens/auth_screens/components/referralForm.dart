import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/models/referralPerson.dart';
import 'package:success_airline/screens/buyPremium.dart';

import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/roundedButton.dart';
import '../../../widgets/smallText.dart';
import '../../../widgets/textfeild2.dart';
import 'loading_screen.dart';

GlobalKey<_ReferralFormState> referralKey = GlobalKey();

class ReferralForm extends StatefulWidget {
  final Map<String, dynamic>? userDetails;

  ReferralForm({Key? key, required this.userDetails}) : super(key: key);

  @override
  State<ReferralForm> createState() => _ReferralFormState();
}

class _ReferralFormState extends State<ReferralForm> {
  final AuthController auth = Get.find();
  bool isLoading = false;
  List<ReferralPerson> referralObj = [
    for (int i = 0; i <= 10; i++) ReferralPerson()
  ];
  @override
  void initState() {
    if (auth.user != null) {
      for (int i = 0; i <= 10; i++) {
        referralObj[i].fName.text = auth.user!.referralList![i]['firstName'];
        referralObj[i].lName.text = auth.user!.referralList![i]['lastName'];
        referralObj[i].email.text = auth.user!.referralList![i]['email'];
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var element in referralObj) {
      element.email.dispose();
      element.fName.dispose();
      element.lName.dispose();
    }
    super.dispose();
  }

  String? firstNameValidator(String? value, int index) {
    if (referralObj[index].fName.text.isNotEmpty ||
        referralObj[index].lName.text.isNotEmpty ||
        referralObj[index].email.text.isNotEmpty) {
      if (value!.trim().isEmpty) {
        return 'Enter first name';
      }
    }
    return null;
  }

  String? lastNameValidator(String? value, int index) {
    if (referralObj[index].fName.text.isNotEmpty ||
        referralObj[index].lName.text.isNotEmpty ||
        referralObj[index].email.text.isNotEmpty) {
      if (value!.trim().isEmpty) {
        return 'Enter Last name';
      }
    }
    return null;
  }

  String? emailValidator(String? value, int index) {
    if (referralObj[index].fName.text.isNotEmpty ||
        referralObj[index].lName.text.isNotEmpty ||
        referralObj[index].email.text.isNotEmpty) {
      if (!GetUtils.isEmail(value!.trim())) {
        return 'Enter a valid email';
      }
    }
    return null;
  }

  void onDone() async {
    bool validate = true;
    List<Map<String, String>> referralList = [];
    for (int i = 0; i < 10; i++) {
      if (!referralObj[i].key.currentState!.validate()) validate = false;
    }
    if (!validate) {
      return;
    } else {
      for (var refer in referralObj) {
        final Map<String, String> map = {
          'firstName': refer.fName.text,
          'lastName': refer.lName.text,
          'email': refer.email.text
        };
        referralList.add(map);
      }
      widget.userDetails!['referralData'] = referralList;

      Get.dialog(const ProgressScreen(), barrierDismissible: false);
      String name = widget.userDetails!['firstName'] +
          ' ' +
          widget.userDetails!['lastName'];
      String email = widget.userDetails!['email'];
      String password = widget.userDetails!['password'];

      await auth
          .signUp(name, email, password, widget.userDetails!)
          .then((value) {
        PURCHASE_ID = '';
        Get.close(7);
      }).catchError((err) {
        String msg = err.toString();
        if (msg.contains('A network error')) {
          msg = 'Please check your internet connection';
        }
        if (msg.contains('email-already-in-use')) {
          msg = 'The email you entered is already exists';
        }

        Get.dialog(
            CupertinoAlertDialog(
              title: const Text('Sign up failed'),
              content: Text(msg),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Get.close(6);
                  },
                )
              ],
            ),
            barrierDismissible: false);
      });
    }
  }

  void update() {
    for (int i = 0; i < 10; i++) {
      if (referralObj[i].key.currentState!.validate()) {
        final Map<String, String> map = {
          'firstName': referralObj[i].fName.text,
          'lastName': referralObj[i].lName.text,
          'email': referralObj[i].email.text
        };
        auth.user!.referralList!.insert(i, map);
      } else {
        return;
      }
    }
    auth
        .saveReferralData(auth.user!.referralList!, auth.user!.id)
        .then((value) => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final String ref = index == 0
              ? '1st'
              : index == 1
                  ? '2nd'
                  : index == 2
                      ? '3rd'
                      : '${index + 1}th';
          if (referralObj.length - index == 1) {
            return Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                RoundedButton(
                  label: 'Done',
                  onPressed: widget.userDetails != null ? onDone : update,
                  // onPressed: onDone,
                ),
                SizedBox(
                  height: 2.h,
                )
              ],
            );
          }
          return Form(
              key: referralObj[index].key,
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  SmallText(
                    size: 13,
                    text: '$ref Referral',
                    color: kprimaryColor,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      CustomTextField(
                          controller: referralObj[index].fName,
                          validator: (val) => firstNameValidator(val, index),
                          isSmall: true,
                          size: const Size(42, 8),
                          hintext: '',
                          prefixIcon: FontAwesomeIcons.userLarge,
                          label: 'First Name'),
                      const Spacer(),
                      CustomTextField(
                          validator: (val) => lastNameValidator(val, index),
                          controller: referralObj[index].lName,
                          isSmall: true,
                          size: const Size(42, 8),
                          hintext: '',
                          prefixIcon: FontAwesomeIcons.userLarge,
                          label: 'Last Name')
                    ],
                  ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  CustomTextField(
                      validator: (val) => emailValidator(val, index),
                      controller: referralObj[index].email,
                      size: Size(90, 8.5),
                      hintext: '',
                      prefixIcon: FontAwesomeIcons.solidEnvelope,
                      label: 'Email'),
                ],
              ));
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 1.h,
            ),
        itemCount: referralObj.length);
  }
}

// Form(
//         child: Column(
//       children: [
// const SmallText(
//   size: 13,
//   text: '1st Referral',
//   color: kprimaryColor,
// ),
// SizedBox(
//   height: 2.h,
// ),
// Row(
//   children: [
//     CustomTextField(
//         onSave: (val) {},
//         validator: firstNameValidator,
//         isSmall: true,
//         size: const Size(42, 7),
//         hintext: '',
//         prefixIcon: FontAwesomeIcons.userLarge,
//         label: 'First Name'),
//     const Spacer(),
//     const CustomTextField(
//         isSmall: true,
//         size: Size(42, 7),
//         hintext: '',
//         prefixIcon: FontAwesomeIcons.userLarge,
//         label: 'Last Name')
//   ],
// ),
// SizedBox(
//   height: 2.h,
// ),
// const CustomTextField(
//     size: Size(90, 7),
//     hintext: '',
//     prefixIcon: FontAwesomeIcons.solidEnvelope,
//     label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '2nd Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '3rd Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '4rt Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '5th Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '6th Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '7th Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '8th Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '9th Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         const SmallText(
//           size: 13,
//           text: '10th Referral',
//           color: kprimaryColor,
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Row(
//           children: const [
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'First Name'),
//             Spacer(),
//             CustomTextField(
//                 isSmall: true,
//                 size: Size(42, 7),
//                 hintext: '',
//                 prefixIcon: FontAwesomeIcons.userLarge,
//                 label: 'Last Name')
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         const CustomTextField(
//             size: Size(90, 7),
//             hintext: '',
//             prefixIcon: FontAwesomeIcons.solidEnvelope,
//             label: 'Email'),
//         SizedBox(
//           height: 4.h,
//         ),
//         RoundedButton(
//           label: 'DONE',
//           onPressed: widget.userDetails != null ? onDone : null,
//           // onPressed: () {
//           //   Get.dialog(
//           //       CupertinoAlertDialog(
//           //         title: Text('Signup failed'),
//           //         content: Text('msg'),
//           //         actions: [
//           //           CupertinoDialogAction(
//           //             child: Text('Ok'),
//           //             onPressed: () {
//           //               Get.close(5);
//           //             },
//           //           )
//           //         ],
//           //       ),
//           //       barrierDismissible: false);
//           // },
//         )
//       ],
//     ));
