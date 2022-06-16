import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/widgets/bigTexT.dart';
import 'package:success_airline/widgets/roundedButton.dart';

class GetStartedScreen extends StatelessWidget {
  final void Function() func;
  const GetStartedScreen({Key? key, required this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        color: const Color(0xffCBE4FE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 2,
            ),
            const BigText(
                text: 'Success airlines', color: Colors.white, size: 30),
            const Spacer(),
            Image.asset(
              'assets/pngs/planeLoop.gif',
            ),
            const Spacer(),
            RoundedButton(
              label: 'GET STARTED',
              onPressed: () async {
                func();
                final sharedPrefs = await SharedPreferences.getInstance();
                sharedPrefs.setBool('showIntro', false);
                // FirebaseAuth.instance.signOut();
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
