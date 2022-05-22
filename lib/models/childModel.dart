import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Child {
  String id;
  final String name;
  final String DOB;
  final String grade;
  final bool isBoy;
  final String photo;

  Child(
      {required this.id,
      required this.name,
      required this.DOB,
      required this.grade,
      required this.isBoy,
      required this.photo});

  factory Child.fromFirestore(QueryDocumentSnapshot snapshot) {
    return Child(
        id: snapshot.get('id'),
        name: snapshot.get('name'),
        DOB: snapshot.get('DOB'),
        grade: snapshot.get('grade'),
        isBoy: snapshot.get('gender') == 'male' ? true : false,
        photo: snapshot.get('image'));
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'DOB': DOB,
      'grade': grade,
      'gender': isBoy ? 'male' : 'female',
      'image': photo
    };
  }
}
