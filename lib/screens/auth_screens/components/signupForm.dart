import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/appuser.dart';
import '../../../widgets/bigTexT.dart';
import '../../../widgets/roundedButton.dart';
import '../../../widgets/smallText.dart';
import '../../../widgets/textfeild2.dart';
import '../addChild_screen.dart';

class SignUpForm extends StatefulWidget {
  final File? image;
  final AppUser? userData;
  const SignUpForm({Key? key, this.image, this.userData}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _fNameController = TextEditingController();

  final _lNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _homeController = TextEditingController();

  final _cityController = TextEditingController();

  final _stateController = TextEditingController();

  final _zipController = TextEditingController();
  final _home2Controller = TextEditingController();
  final _city2Controller = TextEditingController();
  final _state2Controller = TextEditingController();
  final _zip2Controller = TextEditingController();

  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';

  bool isEmailAvailable = true;
  bool isUpdating = false;

  Map<String, String> homeAddress = {
    'home': '',
    'city': '',
    'state': '',
    'zip Code': '',
  };
  Map<String, String> mailingAddress = {
    'home': '',
    'city': '',
    'state': '',
    'zip Code': '',
  };

  final _key = GlobalKey<FormState>();
  final AuthController auth = Get.find();

  void onSave() async {
    if (!_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();
    if (widget.image == null) {
      Get.closeAllSnackbars();
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 4),
        overlayColor: Colors.red,
        backgroundColor: Colors.red,
        title: 'Sign up failed',
        message: 'Please select profile image',
      ));
      return;
    }

    Map<String, dynamic> userDetails = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'homeAddress': homeAddress,
      'mailingAddress': mailingAddress,
      'image': widget.image,
    };

    Get.to(() => AddChildScreen(), arguments: userDetails);
  }

  @override
  void initState() {
    if (widget.userData != null) {
      AppUser? user = widget.userData;
      _fNameController.text = user!.name.split(' ')[0];
      _lNameController.text = user.name.split(' ')[1];
      _emailController.text = user.email!;
      _homeController.text = user.homeAddress['home']!;
      _cityController.text = user.homeAddress['city']!;
      _stateController.text = user.homeAddress['state']!;
      _zipController.text = user.mailingAddress['zipCode']!;
      _home2Controller.text = user.mailingAddress['home']!;
      _city2Controller.text = user.mailingAddress['city']!;
      _state2Controller.text = user.mailingAddress['state']!;
      _zip2Controller.text = user.mailingAddress['zipCode']!;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _homeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _home2Controller.dispose();
    _city2Controller.dispose();
    _state2Controller.dispose();
    _zip2Controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                  controller: _fNameController,
                  validator: (val) {
                    if (val!.trim().isEmpty) return 'Enter your first name';
                    return null;
                  },
                  onSave: (val) {
                    firstName = val!;
                  },
                  hintext: 'Jhon',
                  prefixIcon: FontAwesomeIcons.userLarge,
                  label: 'First Name'),
              CustomTextField(
                  controller: _lNameController,
                  validator: (val) {
                    if (val!.trim().isEmpty) return 'Enter your last name';
                    return null;
                  },
                  onSave: (val) {
                    lastName = val!;
                  },
                  hintext: 'Doe',
                  prefixIcon: FontAwesomeIcons.userLarge,
                  label: 'Last Name'),
              CustomTextField(
                  controller: _emailController,
                  validator: (val) {
                    if (!GetUtils.isEmail(val!.trim())) {
                      return 'Please enter a valid email';
                    }
                    if (!isEmailAvailable) return 'This email already in use';

                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSave: (val) {
                    email = val!;
                  },
                  hintext: 'Jhondoe@gmail.com',
                  prefixIcon: FontAwesomeIcons.solidEnvelope,
                  label: 'Email'),
              // if (widget.userData == null)
              // SizedBox(
              //   height: 2.h,
              // ),
              if (widget.userData == null)
                CustomTextField(
                  validator: (val) {
                    if (val!.trim().length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  onSave: (val) {
                    password = val!;
                  },
                  label: 'Password',
                  hintext: '●●●●●●●●',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                ),
              SizedBox(
                height: 2.h,
              ),
              const SmallText(
                size: 14,
                text: 'Home Address',
                color: Colors.blue,
              ),
              SizedBox(
                height: 2.h,
              ),
              CustomTextField(
                  controller: _homeController,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSave: (val) {
                    homeAddress['home'] = val!;
                  },
                  hintext: '',
                  prefixIcon: FontAwesomeIcons.house,
                  label: 'House Address'),
              CustomTextField(
                controller: _cityController,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                onSave: (val) {
                  homeAddress['city'] = val!;
                },
                hintext: '',
                prefixIcon: FontAwesomeIcons.city,
                label: 'City',
              ),
              CustomTextField(
                  controller: _stateController,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSave: (val) {
                    homeAddress['state'] = val!;
                  },
                  hintext: '',
                  prefixIcon: FontAwesomeIcons.schoolFlag,
                  label: 'State'),
              CustomTextField(
                  controller: _zipController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSave: (val) {
                    homeAddress['zipCode'] = val!;
                  },
                  hintext: '',
                  prefixIcon: FontAwesomeIcons.mapPin,
                  label: 'Zip Code'),
              SizedBox(
                height: 2.h,
              ),
              const SmallText(
                size: 14,
                text: 'Mailing Address',
                color: Colors.blue,
              ),
              SizedBox(
                height: 2.h,
              ),
              CustomTextField(
                  controller: _home2Controller,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSave: (val) {
                    mailingAddress['home'] = val!;
                  },
                  hintext: '',
                  prefixIcon: FontAwesomeIcons.house,
                  label: 'House Address'),
              CustomTextField(
                controller: _city2Controller,
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                onSave: (val) {
                  mailingAddress['city'] = val!;
                },
                hintext: '',
                prefixIcon: Icons.apartment,
                label: 'City',
              ),
              CustomTextField(
                  controller: _state2Controller,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSave: (val) {
                    mailingAddress['state'] = val!;
                  },
                  hintext: '',
                  prefixIcon: FontAwesomeIcons.schoolFlag,
                  label: 'State'),
              CustomTextField(
                  controller: _zip2Controller,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSave: (val) {
                    mailingAddress['zipCode'] = val!;
                  },
                  hintext: '',
                  prefixIcon: FontAwesomeIcons.mapPin,
                  label: 'Zip Code'),
              SizedBox(
                height: 3.h,
              ),
              if (widget.userData == null)
                RoundedButton(
                  onPressed: onSave,
                  label: 'NEXT',
                ),
              if (widget.userData != null && !isUpdating)
                RoundedButton(
                  onPressed: updatePrfile,
                  label: 'Update Profile',
                ),
              if (isUpdating)
                Container(
                  width: 90.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: kprimaryColor),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
                ),
              SizedBox(
                height: 4.h,
              )
            ],
          ),
        ));
  }

  void updatePrfile() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isUpdating = true;
      });
      final String? imageUrl;
      if (widget.image != null) {
        imageUrl = await auth.uploadProfile(widget.image!);
      } else {
        imageUrl = auth.user!.profile;
      }

      auth.user = AppUser(
        id: auth.user!.id,
        email: _emailController.text,
        name: _fNameController.text + " " + _lNameController.text,
        profile: imageUrl,
        homeAddress: {
          'home': _homeController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'zipCode': _zipController.text,
        },
        mailingAddress: {
          'home': _home2Controller.text,
          'city': _city2Controller.text,
          'state': _state2Controller.text,
          'zipCode': _zip2Controller.text,
        },
      );
      // print(auth.user!.toJson());

      auth.updateProfile(auth.user!).then(
            (value) => Get.dialog(
                CupertinoAlertDialog(
                  title: const BigText(
                    size: 14,
                    text: 'Profile Updated',
                    color: Colors.black,
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const SmallText(
                        text: 'OK',
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Get.close(2);
                      },
                    )
                  ],
                ),
                barrierDismissible: false),
          );
    }
  }
}
