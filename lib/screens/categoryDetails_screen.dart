import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/controllers/lessons_controller.dart';
import 'package:success_airline/screens/lessonDetails_screen.dart';
import 'package:success_airline/widgets/roundedButton.dart';
import 'package:success_airline/widgets/smallText.dart';

class CategoryDetailScreen extends StatelessWidget {
  final lessonCont = Get.put(LessonsController());
  final String title;
  final String image;
  CategoryDetailScreen({Key? key, required this.title, required this.image})
      : super(key: key);

  void saveCategoyState(bool isContinue) {
    lessonCont.saveContinueState(isContinue, title);
  }

  @override
  Widget build(BuildContext context) {
    print(image);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: SmallText(
          text: title,
          color: Colors.black,
          size: 18,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            'assets/pngs/abort.png',
            height: 10.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Column(children: [
            SizedBox(
              width: 90.w,
              height: 30.h,
              child: image.contains('.json')
                  ? Lottie.asset(image)
                  : Padding(
                      padding: EdgeInsets.all(4.h), child: Image.asset(image)),
            ),
            SizedBox(
                height: 42.h,
                width: 90.w,
                // color: Colors.red,
                child: FutureBuilder(
                    future: lessonCont.fetchLessons(title),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: const CircularProgressIndicator());
                      }
                      if (lessonCont.lessons.isEmpty)
                        return Center(
                          child: SmallText(
                            size: 18,
                            text: 'No lessons available',
                            color: Colors.black,
                          ),
                        );

                      return ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 2.h,
                        ),
                        itemBuilder: (context, index) => RoundedButton(
                            onPressed: () {
                              Get.to(() => LessonDetailScreen(
                                  save: saveCategoyState,
                                  image: image,
                                  title: title,
                                  lesson: lessonCont.lessons,
                                  index: index));
                            },
                            image: Image.asset('assets/pngs/play.png'),
                            label: lessonCont.lessons[index].title,
                            size: Size(90, 8),
                            radius: 2,
                            textColor: Colors.black,
                            bgColor: kprimaryColor.withOpacity(0.05),
                            icon: Icon(
                              Icons.arrow_forward,
                              color: kprimaryColor,
                              size: 30,
                            )),
                        itemCount: lessonCont.lessons.length,
                      );
                    })),
            InkWell(
              child: Image.asset(
                'assets/pngs/home.png',
                height: 14.h,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Get.back();
              },
            )
          ])),
    );
  }
}
