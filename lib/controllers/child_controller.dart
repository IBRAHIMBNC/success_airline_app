import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:success_airline/controllers/auth_controller.dart';
import 'package:success_airline/models/childModel.dart';

class ChildrenController extends GetxController {
  final AuthController auth = Get.find();
  bool isLoading = true;
  List<Child> _children = [];
  CollectionReference childRef =
      FirebaseFirestore.instance.collection('children');

  List<Child> get children {
    return [..._children];
  }

  Future<void> fetchData({String id = ''}) async {
    if (auth.user == null && id.isEmpty) return;
    String userId = id;
    if (id.isEmpty) userId = auth.user!.id;

    final data = await childRef.doc(userId).collection('childrenDetails').get();
    List<Child> temp = [];
    for (var child in data.docs) {
      temp.add(Child.fromFirestore(child));
    }
    _children = [...temp];
    update();
  }

  Future<void> addChild(Child child) async {
    await childRef
        .doc(auth.user!.id)
        .collection('childrenDetails')
        .add(child.toJson())
        .then((value) {
      child.id = value.id;
      _children.add(child);
      childRef
          .doc(auth.user!.id)
          .collection('childrenDetails')
          .doc(child.id)
          .update({'id': child.id});
    }).then((value) => print('child added'));
    update();
  }

  Future<void> updateProfile(Child childData) async {
    int index = _children.indexWhere((child) => child.id == childData.id);

    _children[index] = childData;
    childRef
        .doc(auth.user!.id)
        .collection('childrenDetails')
        .doc(childData.id)
        .update(childData.toJson());
    update();
  }

  @override
  void onInit() {
    fetchData();
    // TODO: implement onInit
    super.onInit();
  }
}
