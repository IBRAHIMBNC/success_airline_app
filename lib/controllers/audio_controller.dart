// Design and programmed by Syed Muhammad Idrees

import 'package:get/state_manager.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  AudioPlayer? myPlayer;

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
          isPlaying.value = true;
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

  Future startAudio(String url) async {
    if (myPlayer == null) {
      myPlayer = AudioPlayer();
      initateAudioPlayer();
      myPlayer!.setUrl(url);
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
