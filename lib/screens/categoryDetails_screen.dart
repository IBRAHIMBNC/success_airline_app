import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/controllers/idrees_controller.dart';
import 'package:success_airline/controllers/lessons_controller.dart';
import 'package:success_airline/screens/admin_screens/categoryItemDetails_screen.dart';
import 'package:success_airline/screens/lessonDetails_screen.dart';
import 'package:success_airline/widgets/roundedButton.dart';
import 'package:success_airline/widgets/smallText.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String title;
  final String image;
  CategoryDetailScreen({Key? key, required this.title, required this.image});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final lessonCont = Get.put(LessonsController());
  IdreesController idreesController = Get.find();
  updateFuturebuilderCategories() {
    setState(() {});
  }

  @override
  void initState() {
    idreesController.onUpdateCategoriesStream = updateFuturebuilderCategories;
    super.initState();
  }

  void saveCategoyState(bool isContinue) {
    if (!idreesController.isAdmin)
      lessonCont.saveContinueState(isContinue, widget.title);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.image);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: SmallText(
          text: widget.title,
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
              child: widget.image.contains('.json')
                  ? Lottie.asset(widget.image)
                  : Padding(
                      padding: EdgeInsets.all(4.h),
                      child: Image.asset(widget.image)),
            ),
            SizedBox(
                height: 42.h,
                width: 90.w,
                // color: Colors.red,
                child: FutureBuilder(
                    future: lessonCont.fetchLessons(widget.title),
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
                                  image: widget.image,
                                  title: widget.title,
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
            GestureDetector(
              child: Image.asset(
                idreesController.isAdmin
                    ? "assets/pngs/add.png"
                    : 'assets/pngs/home.png',
                height: 14.h,
                fit: BoxFit.cover,
              ),
              onTap: () {
                if (idreesController.isAdmin) {
                  Get.to(() => AddCategoryItemDetailScreen(
                      image: widget.image, category: widget.title));
                } else {
                  Get.back();
                }
              },
            )
          ])),
    );
  }
}
