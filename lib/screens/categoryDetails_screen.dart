import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/controllers/lessons_controller.dart';
import 'package:success_airline/models/lessonModel.dart';
import 'package:success_airline/widgets/roundedButton.dart';
import 'package:success_airline/widgets/smallText.dart';

class CategoryDetailScreen extends StatelessWidget {
  final lessonCont = Get.put(LessonsController());
  final String title;
  CategoryDetailScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: Container(
            // margin: EdgeInsets.only(left: 20),
            child: Image.asset(
              'assets/pngs/abort.png',
              height: 10.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
          width: 100.w,
          height: 100.h,
          child: Column(children: [
            SizedBox(
              height: 30.h,
            ),
            Container(
                height: 45.h,
                width: 90.w,
                child: FutureBuilder(
                    future: lessonCont.fetchLessons(title),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: const CircularProgressIndicator());
                      }

                      return ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 2.h,
                        ),
                        itemBuilder: (context, index) => RoundedButton(
                            image: Image.asset('assets/pngs/play.png'),
                            label: lessonCont.lessons[index].title,
                            size: Size(90, 7),
                            radius: 15,
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
              child: Image.asset('assets/pngs/home.png'),
              onTap: () {},
            )
          ])),
    );
  }
}
