import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';
import '../../widgets/bigTexT.dart';
import '../../widgets/roundedButton.dart';
import '../../widgets/smallText.dart';
import '../../widgets/textfeild2.dart';

import 'referral_screen.dart';

enum ChildAge { age0_3, age4_6, age7_10, age11_13 }

class ChildrenCountScreen extends StatefulWidget {
  final userDetails = Get.arguments as Map<String, dynamic>;
  ChildrenCountScreen({Key? key}) : super(key: key);

  @override
  State<ChildrenCountScreen> createState() => _ChildrenCountScreenState();
}

class _ChildrenCountScreenState extends State<ChildrenCountScreen> {
  final _controller = TextEditingController();
  ChildAge age = ChildAge.age0_3;
  bool isAgree = false;
  @override
  void initState() {
    print(widget.userDetails);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Stack(children: [
            Lottie.asset('assets/json/kidsPlaying.json', height: 30.h),
            Positioned(
                left: 0,
                top: MediaQuery.of(context).padding.top + 2.h,
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios_new))),
          ]),
          SizedBox(height: 1.h),
          const BigText(
            fontWeight: FontWeight.normal,
            text: 'How many Children do\n you have?',
            color: Colors.black,
            size: 24,
          ),
          SizedBox(height: 2.h),
          CustomTextField(
              validator: (val) {
                if (val!.isEmpty) return 'you have at least on child';
                if (int.parse(val) < 1) return 'you have at least on child';
                return null;
              },
              alwaysValidate: true,
              keyboardType: TextInputType.phone,
              controller: _controller,
              hintext: '',
              prefixIcon: FontAwesomeIcons.children,
              label: 'Children'),
          const SmallText(
            text: "Children Ages",
            color: Colors.black45,
            size: 18,
          ),
          SizedBox(
            height: 21.h,
            width: 70.w,
            child: GridView.count(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 2.h,
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              children: [
                RoundedButton(
                  onPressed: () {
                    setState(() {
                      age = ChildAge.age0_3;
                    });
                  },
                  label: '0-3',
                  radius: 15,
                  bgColor: age == ChildAge.age0_3 ? purpleColor : Colors.white,
                  borderLess: age == ChildAge.age0_3 ? true : false,
                  textColor:
                      age == ChildAge.age0_3 ? Colors.white : purpleColor,
                ),
                RoundedButton(
                  onPressed: () {
                    setState(() {
                      age = ChildAge.age4_6;
                    });
                  },
                  label: '4-6',
                  radius: 15,
                  bgColor: age == ChildAge.age4_6 ? purpleColor : Colors.white,
                  borderLess: age == ChildAge.age4_6 ? true : false,
                  textColor:
                      age == ChildAge.age4_6 ? Colors.white : purpleColor,
                ),
                RoundedButton(
                  onPressed: () {
                    setState(() {
                      age = ChildAge.age7_10;
                    });
                  },
                  label: '7-10',
                  radius: 15,
                  bgColor: age == ChildAge.age7_10 ? purpleColor : Colors.white,
                  borderLess: age == ChildAge.age7_10 ? true : false,
                  textColor:
                      age == ChildAge.age7_10 ? Colors.white : purpleColor,
                ),
                RoundedButton(
                  onPressed: () {
                    setState(() {
                      age = ChildAge.age11_13;
                    });
                  },
                  label: '11-13',
                  radius: 15,
                  bgColor:
                      age == ChildAge.age11_13 ? purpleColor : Colors.white,
                  borderLess: age == ChildAge.age11_13 ? true : false,
                  textColor:
                      age == ChildAge.age11_13 ? Colors.white : purpleColor,
                )
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Checkbox(
                  value: isAgree,
                  onChanged: (val) {
                    setState(() {
                      isAgree = val as bool;
                    });
                  }),
              const SmallText(
                text: 'Please sign me up for newsletters and special offers',
                color: Colors.black45,
                size: 10,
              )
            ],
          ),
          RoundedButton(
            bgColor: isAgree ? kprimaryColor : Colors.black45,
            label: 'NEXT',
            onPressed: !isAgree
                ? () {}
                : () {
                    if (int.parse(_controller.text) > 0) {
                      widget.userDetails['children'] = _controller.text;
                      widget.userDetails['childrenAge'] = age.name;
                      Get.to(() => ReferralScreen(),
                          arguments: widget.userDetails);
                    }
                  },
          ),
        ]),
      ),
    );
  }
}
