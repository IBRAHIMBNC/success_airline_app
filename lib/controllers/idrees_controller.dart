import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:path_provider/path_provider.dart';

class IdreesController extends GetxController {
  bool isAdmin = false;

  Function? onUpdateCategoriesStream;

  Future<File> downloadFile(String url, String filename) async {
    var httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = "";

    dir = (await getTemporaryDirectory()).path;

    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes, mode: FileMode.write);

    return file;
  }
}
