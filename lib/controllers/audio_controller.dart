// Design and programmed by Syed Muhammad Idrees

import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:success_airline/controllers/idrees_controller.dart';

class AudioController extends GetxController {
  AudioPlayer? myPlayer;
  IdreesController idreesController = Get.find();
  Duration duration = Duration(seconds: 0);
  RxBool isPlaying = false.obs;
  RxBool isSyncingAudio = false.obs;

  initateAudioPlayer() {
    myPlayer!.playerStateStream.listen((event) {
      var processingState = event.processingState;

      switch (processingState) {
        case ProcessingState.completed:
          stopAudio();
          isPlaying.value = false;
          isSyncingAudio.value = false;
          break;
        case ProcessingState.idle:
          isPlaying.value = false;
          isSyncingAudio.value = false;
          break;
        case ProcessingState.ready:
          isPlaying.value = event.playing;
          isSyncingAudio.value = false;
          break;
        case ProcessingState.buffering:
          isPlaying.value = false;
          isSyncingAudio.value = true;
          break;
        case ProcessingState.loading:
          isSyncingAudio.value = true;
          isPlaying.value = false;
          break;
        default:
      }
    });
  }

  Future startAudio(String url, String name) async {
    if (myPlayer == null) {
      myPlayer = AudioPlayer();
      initateAudioPlayer();

      String filename = name.replaceAll(' ', "") + ".mp3";
      String dir = (await getTemporaryDirectory()).path;

      File file = File('$dir/$filename');

      bool isFileExist = await file.exists();
      if (isFileExist) {
        myPlayer!.setFilePath(file.path);
      } else {
        isSyncingAudio.value = true;
        file = await idreesController.downloadFile(url, filename);
        //isSyncingAudio.value = false;
        myPlayer!.setFilePath(file.path);
      }

      myPlayer!.play();
    }
  }

  stopAudio() async {
    if (myPlayer != null) {
      isPlaying.value = false;
      isSyncingAudio.value = false;

      duration = Duration(seconds: 0);
      await myPlayer!.stop();
      await myPlayer!.dispose();
      myPlayer = null;
    }
  }
}
