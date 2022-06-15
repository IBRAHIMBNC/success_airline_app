// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:success_airline/controllers/auth_controller.dart';
import 'package:success_airline/models/lessonModel.dart';

class LessonsController extends GetxController {
  final AuthController auth = Get.find();
  final lessonRef = FirebaseFirestore.instance.collection('allCategories');
  final continueCatgoryRef =
      FirebaseFirestore.instance.collection('continueCategories');
  Reference storageRef = FirebaseStorage.instance.ref();
  List<Lesson> _lessons = [];
  List<Map<String, dynamic>> continuedCategories = [];

  List<Lesson> get lessons {
    return [..._lessons];
  }

  Future<void> uploadLesson(Lesson les, String category) async {
    final response =
        await lessonRef.doc(category).collection('lessons').add(les.toJason());

    await lessonRef
        .doc(category)
        .collection('lessons')
        .doc(response.id)
        .update({'id': response.id});
  }

  Future<void> updateLesson(Lesson les, String category) async {
    await lessonRef
        .doc(category)
        .collection('lessons')
        .doc(les.id)
        .update(les.toJason());
  }

  Future<void> deleteLesson(Lesson les, String category) async {
    await lessonRef.doc(category).collection('lessons').doc(les.id).delete();
  }

  Future<String> uploadAudio(File file) async {
    final String id = DateTime.now().toIso8601String();
    storageRef = storageRef.child('audioFiles').child(id + '.mp3');
    TaskSnapshot snapshot = await storageRef.putFile(file);
    String audioLink = await snapshot.ref.getDownloadURL();
    return audioLink;
  }

  Future<void> fetchLessons(String category) async {
    final lessons = await lessonRef.doc(category).collection('lessons').get();
    final temp = [];
    lessons.docs.forEach((lesson) {
      Lesson ss = Lesson.fromFirebase(lesson);

      temp.add(ss);
    });
    _lessons = [...temp];
    update();
  }

  Future<List<Map<String, dynamic>>> fetchContinueCategory() async {
    final data = await continueCatgoryRef
        .doc(auth.user!.id)
        .collection('category')
        .where('isContinue', isEqualTo: true)
        .get()
        .catchError((err) {
      print(err);
    });
    final temp = [];
    data.docs.forEach((categoty) {
      temp.add(categoty.data());
    });
    continuedCategories = [...temp];

    return continuedCategories;
  }

  void saveContinueState(bool isContinue, String category) async {
    continuedCategories.add({'name': category, 'isContinue': isContinue});
    await continueCatgoryRef
        .doc(auth.user!.id)
        .collection('category')
        .doc(category)
        .set({'name': category, 'isContinue': isContinue});

    update();
  }
}
