import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:success_airline/contants/appContants.dart';
import 'package:success_airline/controllers/idrees_controller.dart';
import 'package:success_airline/screens/buyPremium.dart';
import '../models/appuser.dart';

class AuthController extends GetxController {
  final auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection('users');
  final childrenRef = FirebaseFirestore.instance.collection('children');
  final purchaseRef = FirebaseFirestore.instance.collection('purchases');
  Reference storageRef = FirebaseStorage.instance.ref();
  String? purchasId;
  bool isHost = false;
  AppUser? user;

  Future<void> signUp(String name, String email, String password,
      Map<String, dynamic> userDetails) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((err) {
      throw err;
    });
    String picUrl = '';
    if (userDetails['image'] == '') {
      picUrl = defaultProfile;
    } else {
      await uploadProfile(userDetails['image']);
    }

    await auth.currentUser!.updatePhotoURL(picUrl);
    if (auth.currentUser != null) {
      userDetails['image'] = auth.currentUser!.photoURL;
      await saveUserdata(auth.currentUser, userDetails);
      saveReferralData(userDetails['referralData'], auth.currentUser!.uid);

      user = AppUser(
          profile: userDetails['image'],
          name: name,
          email: email,
          id: auth.currentUser!.uid,
          homeAddress: userDetails['homeAddress'],
          mailingAddress: userDetails['mailingAddress'],
          referralList: userDetails['referralData']);
      purchaseRef.doc(user!.id).set({
        'purchaseID': userDetails['purchaseId'],
        'expiryDate': userDetails['expiryDate']
      });
    }
  }

  Future<void> saveReferralData(List<dynamic> referrelList, String id) async {
    await userRef.doc(id).update({'referralData': referrelList});
  }

  Future<String> uploadProfile(File image) async {
    final String picId = DateTime.now().toIso8601String();
    storageRef = storageRef.child('profiles').child(picId + '.jpg');
    TaskSnapshot storageSnap = await storageRef.putFile(image);
    String mediaUrl = await storageSnap.ref.getDownloadURL();
    print('uploadImage');
    return mediaUrl;
  }

  Future<void> signIn(String email, String password) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((err) {
      throw err;
    });
    if (auth.currentUser!.email == 'admin@gmail.com') {
      Get.find<IdreesController>().isAdmin = true;
      return;
    } else {
      Get.find<IdreesController>().isAdmin = false;
    }
    final userData = await userRef.doc(auth.currentUser!.uid).get();
    user = AppUser.fromFirebase(userData);
    varifyUser().then((value) {
      if (!value) {
        Get.to(() => PremiumPlanScreen(),
            arguments: {'oldPurchaseId': purchasId});
      }
    });

    update();
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> saveUserdata(
      User? user, Map<String, dynamic> userDetails) async {
    userDetails['id'] = user!.uid;

    userDetails.removeWhere((key, value) => key == 'password');
    if (userDetails.containsKey('childDetails')) {
      final url = await uploadProfile(userDetails['childDetails']['image']);
      userDetails['childDetails']['image'] = url;
      final doc =
          await childrenRef.doc(user.uid).collection('childrenDetails').add({});
      // print(doc.id);
      userDetails['childDetails']['id'] = doc.id;
      childrenRef
          .doc(user.uid)
          .collection('childrenDetails')
          .doc(doc.id)
          .set(userDetails['childDetails']);
    }
    await userRef.doc(user.uid).set(userDetails);
  }

  void fetchUserData() async {
    if (auth.currentUser != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      user = AppUser.fromFirebase(userData);
      varifyUser().then((value) {
        if (!value) signOut();
      });
    }
    update();
  }

  Future<List<AppUser>> fetchAllUsers({String searchKeyword = ''}) async {
    QuerySnapshot<Map<String, dynamic>> allUsersDocs;
    if (searchKeyword.isEmpty) {
      allUsersDocs =
          await userRef.where('firstName', isNotEqualTo: 'admin').get();
    } else {
      allUsersDocs = await userRef
          .where(
            'firstName',
          )
          .where('firstName', isNotEqualTo: 'admin')
          .get();
      if (allUsersDocs.docs.isEmpty) {
        allUsersDocs = await userRef
            .where(
              'lastName',
              isGreaterThanOrEqualTo: searchKeyword,
            )
            .where('firstName', isNotEqualTo: 'admin')
            .get();
      }
    }
    final List<AppUser> users = [];

    for (var user in allUsersDocs.docs) {
      users.add(AppUser.fromFirebaseWithChildrenDetails(user));
    }
    return users;
  }

  Future<void> updateProfile(AppUser user) async {
    final mapData = user.toJson();
    await userRef.doc(user.id).update(mapData);
  }

  Future<bool> varifyUser() async {
    final purchaseDoc = await purchaseRef.doc(user!.id).get();

    Timestamp timeStamp = purchaseDoc.get('expiryDate');
    purchasId = purchaseDoc.get('purchaseID');
    DateTime exDate = timeStamp.toDate();
    if (exDate.isBefore(DateTime.now())) return false;

    return true;
  }

  @override
  void onInit() {
    if (auth.currentUser?.email != 'admin@gmail.com') fetchUserData();
    super.onInit();
  }
}
