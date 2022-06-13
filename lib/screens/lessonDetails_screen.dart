import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/models/lessonModel.dart';
import 'package:success_airline/widgets/smallText.dart';

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
  AudioPlayer? audio;
  bool isPlay = false;
  int currentLessonIndex = 0;
  bool isContinue = true;
  @override
  void initState() {
    currentLessonIndex = widget.index;

    super.initState();
  }

  @override
  void dispose() {
    if (audio != null) audio?.dispose();
    widget.save!(isContinue);
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
        leading: GestureDetector(onTap: () {}),
      ),
      body: Container(
          height: 100.h,
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
                height: 45.h,
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
                        const Spacer(
                          flex: 1,
                        ),
                        const SmallText(
                          text: 'Definition',
                          size: 18,
                        ),
                        const Spacer(),
                        Expanded(
                          child: SmallText(
                            text: widget.lesson[currentLessonIndex].description,
                            size: 18,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (currentLessonIndex > 0) {
                                    audio?.stop();
                                    setState(() {
                                      currentLessonIndex--;
                                      isPlay = false;
                                      audio = null;
                                    });
                                  }
                                },
                                child: Image.asset(
                                  'assets/pngs/arrow_back.png',
                                  height: 13.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (audio == null) {
                                    audio = AudioPlayer();
                                    await audio!.play(widget
                                        .lesson[currentLessonIndex].audioLink);
                                    setState(() {
                                      isPlay = true;
                                    });
                                  } else {
                                    if (isPlay) {
                                      audio!.pause();
                                      setState(() {
                                        isPlay = false;
                                      });
                                    } else {
                                      audio!.resume();
                                      setState(() {
                                        isPlay = true;
                                      });
                                    }
                                  }
                                },
                                child: Image.asset(
                                  isPlay
                                      ? 'assets/pngs/pause.png'
                                      : 'assets/pngs/play.png',
                                  height: 13.5.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (currentLessonIndex <
                                      widget.lesson.length - 1) {
                                    audio?.stop();

                                    setState(() {
                                      isPlay = false;
                                      currentLessonIndex++;
                                      audio = null;
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
                          if (audio != null) audio!.stop();
                          Get.back();
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/pngs/abort.png'),
                          radius: 6.h,
                          backgroundColor: Colors.white,
                        ),
                      )),
                ]),
              )
            ],
          )),
    );
  }
}
