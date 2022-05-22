import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CircleProfileImage extends StatelessWidget {
  final String url;
  final Function()? onPressed;
  final double size = 9;
  const CircleProfileImage({Key? key, this.onPressed, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: size.h,
        width: size.h,
        child: Stack(children: [
          Image.asset(
            'assets/pngs/childAvater.png',
            height: size.h,
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: (size / 3.1).h,
              backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(url),
            ),
          ),
        ]),
      ),
    );
  }
}
