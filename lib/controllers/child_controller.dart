import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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

  Future<List<Child>> fetchData({String id = ''}) async {
    String userId;
    if (id.isNotEmpty) {
      userId = id;
    } else {
      userId = auth.user!.id;
    }

    final data = await childRef.doc(userId).collection('childrenDetails').get();
    List<Child> temp = [];
    for (var child in data.docs) {
      temp.add(Child.fromFirestore(child));
    }
    return [...temp];
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
    if (auth.user != null) {
      fetchData().then((value) => _children = value.isEmpty ? [] : value);
    }
    // TODO: implement onInit
    super.onInit();
  }
}
