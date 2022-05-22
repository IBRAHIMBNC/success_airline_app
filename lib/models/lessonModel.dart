import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  String id;
  final String title;
  final String description;
  final String audioLink;

  Lesson(this.id, this.title, this.description, this.audioLink);

  Map<String, dynamic> toJason() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'audioLink': audioLink
    };
  }

  factory Lesson.fromFirebase(QueryDocumentSnapshot doc) {
    return Lesson(
        doc.get('id'), doc.get('title'), doc.get('description'), 'audioLink');
  }
}
