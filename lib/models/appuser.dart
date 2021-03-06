import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_airline/contants/appContants.dart';

class AppUser {
  final String id;
  final String profile;
  final String name;
  final Map<String, String> mailingAddress;
  final String? email;
  String? children;
  String? childrenAges;
  String? hearAboutUs;
  List<dynamic>? referralList;

  AppUser(
      {required this.name,
      required this.profile,
      required this.email,
      required this.id,
      required this.mailingAddress,
      this.referralList});
  AppUser.withChildrenDetails({
    required this.name,
    required this.profile,
    required this.email,
    required this.id,
    required this.mailingAddress,
    required this.children,
    required this.childrenAges,
    required this.hearAboutUs,
  });

  factory AppUser.fromFirebase(DocumentSnapshot userData) {
    return AppUser(
        mailingAddress:
            Map<String, String>.from(userData.get('mailingAddress')),
        id: userData.get('id'),
        name: userData.get('firstName') + ' ' + userData.get('lastName'),
        email: userData.get('email'),
        profile: userData.get('image'),
        referralList: (userData.get('referralData')));
  }
  factory AppUser.fromFirebaseWithChildrenDetails(DocumentSnapshot userData) {
    // String email = userData.get("email");

    // Map<String, dynamic> s = userData.data() as Map<String, dynamic>;

    return AppUser.withChildrenDetails(
        mailingAddress:
            Map<String, String>.from(userData.get('mailingAddress')),
        id: userData.get('id'),
        name: userData.get('firstName') + ' ' + userData.get('lastName'),
        email: userData.get('email'),
        profile: userData.get('image') ?? defaultProfile,
        children: userData.get('children'),
        childrenAges: userData.get('childrenAge'),
        hearAboutUs: userData.get('hearAboutUs'));
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': name.split(' ')[0],
      'lastName': name.split(' ')[1],
      'email': email,
      'id': id,
      'image': profile,
      'mailingAddress': mailingAddress
    };
  }
}
