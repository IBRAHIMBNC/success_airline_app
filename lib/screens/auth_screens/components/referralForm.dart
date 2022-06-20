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
      Get.to(
        () => PremiumPlanScreen(),
        arguments: widget.userDetails,
      );
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
