import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TextFieldContainer extends StatefulWidget {
  final TextFormField textFormField;
  final bool isPassword;
  final Icon prefix;
  const TextFieldContainer(
      {Key? key,
      required this.textFormField,
      this.isPassword = false,
      required this.prefix})
      : super(key: key);

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  bool isHide = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
      ),
      height: 7.h,
      width: 90.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black26,
          )),
      child: Row(children: [
        widget.prefix,
        SizedBox(
          width: 3.w,
        ),
        Expanded(child: widget.textFormField),
        if (widget.isPassword)
          GestureDetector(
              onTap: () {
                setState(() {
                  isHide = !isHide;
                });
              },
              child: Icon(isHide ? Icons.visibility : Icons.visibility_off))
      ]),
    );
  }
}
