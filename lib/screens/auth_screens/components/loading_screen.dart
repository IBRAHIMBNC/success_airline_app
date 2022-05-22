import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.black,
          ),
          height: 20.h,
          width: 50.w,
          child: Center(
            child: CupertinoActivityIndicator(
              radius: 2.h,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
