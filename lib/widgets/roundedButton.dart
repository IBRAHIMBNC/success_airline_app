import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';
import 'smallText.dart';

class RoundedButton extends StatelessWidget {
  final Function()? onPressed;
  bool isLoading;

  final Widget? image;
  final String label;
  final Color bgColor;
  final Color textColor;
  final Size size;
  final bool borderLess;
  final double radius;
  final Icon? icon;

  RoundedButton(
      {Key? key,
      this.onPressed,
      required this.label,
      this.bgColor = kprimaryColor,
      this.textColor = Colors.white,
      this.size = const Size(90, 7.5),
      this.borderLess = true,
      this.radius = 30,
      this.icon,
      this.image,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isLoading ? onPressed : () {},
      child: Container(
        alignment: Alignment.center,
        width: size.width.w,
        height: size.height.h,
        decoration: BoxDecoration(
            border: !borderLess ? Border.all(color: Colors.black38) : null,
            borderRadius: BorderRadius.circular(radius),
            color: bgColor),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : icon == null
                ? SmallText(
                    color: textColor,
                    text: label,
                    size: 16,
                  )
                : Row(
                    children: [
                      SizedBox(
                        width: 4.w,
                      ),
                      if (image != null) image!,
                      SizedBox(
                        width: 4.w,
                      ),
                      SmallText(
                        color: textColor,
                        text: label,
                        size: 16,
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      icon!,
                      SizedBox(
                        width: 3.w,
                      )
                    ],
                  ),
      ),
    );
  }
}
