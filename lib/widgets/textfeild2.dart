import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType keyboardType;
  final EdgeInsets prefixIconPadding;
  final bool alwaysValidate;
  final String label;
  final String? hintext;
  final Color? bgColor;
  final IconData prefixIcon;
  final Widget? prefix;
  final bool isPassword;
  final double? borderRadius;
  final String? Function(String?)? validator;
  final Function(String? val)? onSave;
  final Size size;
  final bool isSmall;
  final TextEditingController? controller;
  final int? lines;
  const CustomTextField({
    Key? key,
    this.hintext,
    required this.prefixIcon,
    this.isPassword = false,
    this.onSave,
    this.validator,
    this.bgColor,
    this.borderRadius = 15,
    required this.label,
    this.size = const Size(90, 9),
    this.isSmall = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.alwaysValidate = false,
    this.lines,
    this.prefix,
    this.prefixIconPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isVisible;

  @override
  void initState() {
    isVisible = widget.isPassword;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width.w,
      height: widget.size.height.h,
      child: TextFormField(
          maxLines: widget.lines ?? 1,
          style: TextStyle(fontSize: 16.sp),
          autovalidateMode:
              widget.alwaysValidate ? AutovalidateMode.onUserInteraction : null,
          controller: widget.controller,
          validator: widget.validator,
          onSaved: widget.onSave,
          keyboardType: widget.keyboardType,
          obscureText: isVisible,
          obscuringCharacter: '●',
          decoration: InputDecoration(
            alignLabelWithHint: true,
            prefix: widget.prefix,
            labelText: widget.label,
            prefixIcon: Padding(
              padding: widget.prefixIconPadding,
              child: Icon(
                widget.prefixIcon,
                // size: 3.5.h,
              ),
            ),
            labelStyle: TextStyle(fontSize: 15.sp, color: Colors.black45),
            border: InputBorder.none,
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                borderSide: const BorderSide(color: Colors.red)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                borderSide: const BorderSide(color: Colors.red)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                borderSide: const BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                borderSide: const BorderSide(color: purpleColor)),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black45,
                    ),
                  )
                : null,
          )),
    );
  }
}

class DatePickerField extends StatefulWidget {
  final String label;
  final Color? bgColor;
  final IconData prefexIcon;
  final double? borderRadius;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final Function(String?)? onSave;
  final Size size;
  final TextEditingController? controller;

  const DatePickerField(
      {Key? key,
      required this.label,
      this.bgColor,
      required this.prefexIcon,
      this.borderRadius = 15,
      this.validator,
      this.onTap,
      required this.size,
      this.controller,
      this.onSave})
      : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.size.height.h,
      ),
      width: widget.size.width.w,
      child: TextFormField(
          onSaved: widget.onSave,
          onTap: () {
            showDatePicker(
                    builder: (context, child) => Theme(
                          data: ThemeData.light().copyWith(
                              primaryColor: kprimaryColor,
                              colorScheme:
                                  ColorScheme.light(primary: kprimaryColor)),
                          child: child!,
                        ),
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(Duration(days: 365 * 13)),
                    lastDate: DateTime.now())
                .then((value) {
              if (value != null)
                widget.controller!.text =
                    DateFormat('d MMM, yyyy').format(value);
            });
          },
          readOnly: true,
          style: TextStyle(fontSize: 16.sp),
          controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                borderSide: const BorderSide(color: purpleColor),
              ),
              labelText: widget.label,
              labelStyle: TextStyle(fontSize: 15.sp, color: Colors.black45),
              border: InputBorder.none,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(color: Colors.red)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(color: Colors.red)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(color: Colors.black26)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius!),
                  borderSide: const BorderSide(color: purpleColor)),
              prefixIcon: Icon(widget.prefexIcon))),
    );
  }
}
