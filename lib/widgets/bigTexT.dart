import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BigText extends StatelessWidget {
  final Color color;
  final String text;
  final int size;
  final FontWeight fontWeight;
  const BigText(
      {Key? key,
      this.color = Colors.white,
      required this.text,
      this.size = 18,
      this.fontWeight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: size.sp,
        fontWeight: fontWeight,
      ),
    );
  }
}
