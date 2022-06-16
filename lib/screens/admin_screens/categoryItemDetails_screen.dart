// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/controllers/idrees_controller.dart';
import 'package:success_airline/controllers/lessons_controller.dart';
import 'package:success_airline/models/lessonModel.dart';
import 'package:success_airline/widgets/bigTexT.dart';
import 'package:success_airline/widgets/roundedButton.dart';
import 'package:success_airline/widgets/smallText.dart';
import 'package:success_airline/widgets/textfeild2.dart';

class AddCategoryItemDetailScreen extends StatelessWidget {
  final lessonCont = Get.put(LessonsController());
  final _key = GlobalKey<FormState>();
  final String category;
  final String image;
  String? title;
  String? description;
  String? audioUrl;
  Rx<bool> isLoading = false.obs;
  Rx<File?> audioFile = File('').obs;
  File? downloadedFile;
  bool isUpdate;
  Lesson? lesson;
  IdreesController idreesController = Get.find();
  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtDescription = TextEditingController();

  AddCategoryItemDetailScreen(
      {Key? key,
      required this.category,
      required this.image,
      this.isUpdate = false,
      this.lesson}) {
    if (isUpdate) {
      updateDataonAdmin();
    }
  }

  updateDataonAdmin() async {
    txtTitle.text = lesson!.title;
    txtDescription.text = lesson!.description;
    isLoading.value = true;
    audioFile.value =
        await idreesController.downloadFile(lesson!.audioLink, "test.mp3");
    downloadedFile = audioFile.value;
    isLoading.value = false;
  }

  void selectAudio() async {
    final FilePickerResult? result;
    if (Platform.isIOS) {
      result = await FilePicker.platform
          .pickFiles(
        type: FileType.custom,
        allowedExtensions: ['.mp3'],
        allowMultiple: false,
      )
          .catchError((err) {
        print(err);
      });
      if (result != null) {
        audioFile.value = File(result.files.first.path!);
      }
    } else {
      result = await FilePicker.platform
          .pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      )
          .catchError((err) {
        print(err);
      });
      if (result != null) {
        audioFile.value = File(result.files.first.path!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BigText(
            size: 22,
            text: category,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Obx(
            () => GestureDetector(
              onTap: isLoading.value
                  ? () {}
                  : () {
                      Get.back();
                    },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            // height: .h,
            width: 100.w,
            child: Column(children: [
              SizedBox(
                width: 90.w,
                height: 25.h,
                child: image.contains('.json')
                    ? Lottie.asset(image)
                    : Padding(
                        padding: EdgeInsets.all(4.h),
                        child: Image.asset(image)),
              ),
              SizedBox(
                height: 2.h,
              ),
              BigText(
                fontWeight: FontWeight.normal,
                text: isUpdate ? "Update Content" : 'Add Content',
                color: Colors.black,
                size: 22,
              ),
              SizedBox(
                height: 2.h,
              ),
              Form(
                  key: _key,
                  child: Column(
                    children: [
                      CustomTextField(
                        prefixIcon: FontAwesomeIcons.t,
                        label: 'Title',
                        controller: txtTitle,
                        onSave: (val) {
                          title = val;
                          print(title);
                        },
                        validator: (val) {
                          if (val!.trim().isEmpty) return 'Please enter title';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      CustomTextField(
                        onSave: (val) {
                          description = val;
                          print(description);
                        },
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Description must be at least 20 characters';
                          }
                          return null;
                        },
                        size: Size(90, 15),
                        controller: txtDescription,
                        prefixIcon: FontAwesomeIcons.fileCircleExclamation,
                        label: 'Desciption',
                        keyboardType: TextInputType.multiline,
                        lines: 20,
                      ),
                    ],
                  )),
              SizedBox(
                height: 2.h,
              ),
              InkWell(
                onTap: selectAudio,
                child: DottedBorder(
                  dashPattern: const [8],
                  color: kprimaryColor,
                  strokeWidth: 2,
                  radius: Radius.circular(15),
                  borderType: BorderType.RRect,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    height: 9.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(children: [
                      Spacer(
                        flex: 1,
                      ),
                      SvgPicture.asset(
                        'assets/svgs/audioFileIcon.svg',
                        height: 5.h,
                      ),
                      Spacer(),
                      Obx(
                        () => SmallText(
                          text: audioFile.value!.path == ''
                              ? 'Upload Audio File'
                              : 'File Selected',
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Obx(
                () => RoundedButton(
                  isLoading: isLoading.value,
                  label: 'Publish',
                  onPressed: () {
                    // print(lesson!.audioLink);
                    // return;
                    // Focus.of(context).unfocus();
                    publish();
                  },
                ),
              ),
              SizedBox(
                height: 5.h,
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> publish() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      if (audioFile.value!.path == '') {
        Get.snackbar('Publish failed', 'Please select audio file',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        return;
      }
      isLoading.value = true;

      if (downloadedFile == null ||
          downloadedFile!.path != audioFile.value!.path) {
        audioUrl = await lessonCont.uploadAudio(audioFile.value!);
      } else {
        audioUrl = lesson!.audioLink;
      }

      if (isUpdate) {
        String ss = lesson!.id;
        Lesson less = Lesson(ss, txtTitle.text, txtDescription.text, audioUrl!);
        lessonCont.updateLesson(less, category).then((value) {
          Get.snackbar('Lesson Updated', 'Lesson updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: Colors.green);
        }).then((value) {
          idreesController.onUpdateCategoriesStream?.call();
          Get.close(2);
        });
      } else {
        final lesson = Lesson('', title!, description!, audioUrl!);
        lessonCont.uploadLesson(lesson, category).then((value) {
          Get.snackbar('Lesson Uploaded', 'Lesson uploaded successfully',
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: Colors.green);
        }).then((value) {
          idreesController.onUpdateCategoriesStream?.call();
          Get.close(1);
        });
      }
    }
  }
}
