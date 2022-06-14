import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/controllers/audio_controller.dart';
import 'package:success_airline/models/lessonModel.dart';
import 'package:success_airline/widgets/smallText.dart';

import '../controllers/idrees_controller.dart';
import 'admin_screens/categoryItemDetails_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final List<Lesson> lesson;
  final String image;
  final String title;
  final int index;
  final Function(bool isContinue)? save;

  const LessonDetailScreen(
      {Key? key,
      required this.lesson,
      required this.title,
      required this.index,
      required this.image,
      this.save})
      : super(key: key);

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int currentLessonIndex = 0;
  bool isContinue = true;

  AudioController audioController = Get.find();

  @override
  void initState() {
    currentLessonIndex = widget.index;

    super.initState();
  }

  @override
  void dispose() {
    audioController.stopAudio();

    if (!Get.find<IdreesController>().isAdmin) widget.save!(isContinue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SmallText(
          text: widget.title,
          color: Colors.black,
          size: 18,
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 060,
            width: 60,
            child: Center(
              child: Image(
                image: AssetImage("assets/pngs/arrow_back.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 060,
              width: 60,
              child: Center(
                child: Image(
                  image: AssetImage("assets/pngs/arrow_forward.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
          height: 200.h,
          width: 100.w,
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
                child: widget.image.contains('.json')
                    ? Lottie.asset(widget.image)
                    : Image.asset(widget.image),
              ),
              SmallText(
                text: widget.lesson[currentLessonIndex].title,
                color: Colors.black,
                size: 24,
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5.h),
                alignment: Alignment.center,
                height: 50.h,
                width: 90.w,
                child: Stack(clipBehavior: Clip.none, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      height: 45.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.h),
                        color: orangeColor,
                      ),
                      child: Column(children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        const SmallText(
                          text: 'Definition',
                          size: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 14.h,
                          width: 85.w,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SmallText(
                                text: widget
                                    .lesson[currentLessonIndex].description,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (currentLessonIndex > 0) {
                                    audioController.stopAudio();
                                    setState(() {
                                      currentLessonIndex--;
                                    });
                                  }
                                },
                                child: Image.asset(
                                  'assets/pngs/arrow_back.png',
                                  height: 13.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (audioController.myPlayer == null) {
                                    audioController.startAudio(widget
                                        .lesson[currentLessonIndex].audioLink);
                                  } else {
                                    if (audioController.isPlaying.value) {
                                      audioController.myPlayer!.pause();
                                    } else {
                                      audioController.myPlayer!.play();
                                    }
                                  }
                                },
                                child: Obx(() {
                                  return audioController.isSyncingAudio.value
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Image.asset(
                                          audioController.isPlaying.value
                                              ? 'assets/pngs/pause.png'
                                              : 'assets/pngs/play.png',
                                          height: 13.5.h,
                                          fit: BoxFit.cover,
                                        );
                                }),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (currentLessonIndex <
                                      widget.lesson.length - 1) {
                                    audioController.stopAudio();
                                    setState(() {
                                      currentLessonIndex++;
                                    });
                                  }
                                },
                                child: Image.asset(
                                  'assets/pngs/arrow_forward.png',
                                  height: 13.h,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                      ]),
                    ),
                  ),
                  Positioned(
                      bottom: -2.3.h,
                      left: 45.w - 6.h,
                      child: InkWell(
                        onTap: () {
                          if (currentLessonIndex == widget.lesson.length - 1) {
                            isContinue = false;
                          }
                          widget.save!(isContinue);
                          if (audioController.myPlayer != null)
                            audioController.stopAudio();
                          Get.back();
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/pngs/abort.png'),
                          radius: 6.h,
                          backgroundColor: Colors.white,
                        ),
                      )),
                  if (Get.find<IdreesController>().isAdmin)
                    Positioned(
                        top: -1.2.h,
                        right: -1.2.h,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => AddCategoryItemDetailScreen(
                                  image: widget.image,
                                  category: widget.title,
                                ));
                          },
                          child: Container(
                            height: 060,
                            width: 60,
                            child: Center(
                              child: Image(
                                image:
                                    AssetImage("assets/pngs/arrow_forward.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                ]),
              )
            ],
          )),
    );
  }
}
