import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:success_airline/models/lessonModel.dart';
import 'package:uuid/uuid.dart';

class LessonsController extends GetxController {
  final lessonRef = FirebaseFirestore.instance.collection('allCategories');
  Reference storageRef = FirebaseStorage.instance.ref();
  List<Lesson> _lessons = [];

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
      temp.add(Lesson.fromFirebase(lesson));
    });
    _lessons = [...temp];
    update();
  }
}
