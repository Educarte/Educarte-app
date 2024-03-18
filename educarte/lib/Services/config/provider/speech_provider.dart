import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum SpeechProviderState { init, started, done, error, finish }

class SpeechProvider extends ChangeNotifier {
  SpeechProviderState _status = SpeechProviderState.init;
  SpeechProviderState get status => _status;

  String _currentLocaleId = '';
  String get currentLocaleId => _currentLocaleId;

  bool _hasSpeech = false;
  bool get hasSpeech => _hasSpeech;

  double _level = 0.0;
  double get level => _level;

  double _minSoundLevel = 50000;
  double get minSoundLevel => _minSoundLevel;

  double _maxSoundLevel = -50000;
  double get maxSoundLevel => _maxSoundLevel;

  final SpeechToText speech = SpeechToText();
  late BuildContext currentContext;
  late TextEditingController controller;

  void changeState({required SpeechProviderState receivedState}) {
    _status = receivedState;

    notifyListeners();
  }

  void changeStatus({required SpeechProviderState receivedStatus}) {
    _status = receivedStatus;

    notifyListeners();
  }

  void resetSpeech() => _hasSpeech = false;

  Future checkMicrophone({required BuildContext context}) async {
    if (await Permission.microphone.isDenied || await Permission.microphone.isPermanentlyDenied) {
      await Permission.microphone.request().then((permission) {
        if (permission == PermissionStatus.granted) {
          startListening(context: context);
        }
      });
    } else {
      if(context.mounted){
        startListening(context: context);
      } 
    }
  }

  Future<void> initSpeechState({
    required BuildContext context,
    required TextEditingController currentController
  }) async {
    try {
      currentContext = context;
      controller = currentController;
      _hasSpeech = false;

      changeState(receivedState: SpeechProviderState.init);

      var curretnHasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
      );

      if (hasSpeech) {
        var systemLocale = await speech.systemLocale();

        _currentLocaleId = systemLocale?.localeId ?? '';
      }

      if (!context.mounted) return;

      _hasSpeech = curretnHasSpeech;

      await checkMicrophone(context: context);
    } catch (e) {
      _hasSpeech = false;

      changeState(receivedState: SpeechProviderState.done);
    }
  }

  Future<void> startListening({required BuildContext context,}) async {
    try {
      currentContext = context;
      changeState(receivedState: SpeechProviderState.started);

      await speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation
      );
    } catch (e) {
      changeState(receivedState: SpeechProviderState.error);
    }
  }

  void resultListener(SpeechRecognitionResult result) {
    if (result.finalResult && result.alternates.first.recognizedWords.isNotEmpty) {
      controller.text = result.recognizedWords;

      changeState(receivedState: SpeechProviderState.finish);

      Navigator.pop(currentContext);
    }
  }

  void errorListener(SpeechRecognitionError error) {
    if (error.errorMsg == "error_no_match" ||
        error.errorMsg == "error_speech_timeout" ||
        error.errorMsg == "error_network") {
      changeState(receivedState: SpeechProviderState.error);
    }
  }

  void statusListener(String status) {
    if (status == "done") {
      changeState(receivedState: SpeechProviderState.done);
    }
  }

  void stopListening() {
    speech.stop();

    _level = 0.0;

    changeState(receivedState: SpeechProviderState.done);
  }

  void cancelListening() {
    speech.cancel();

    _level = 0.0;

    changeState(receivedState: SpeechProviderState.done);
  }

  void soundLevelListener(double level) {
    _minSoundLevel = min(minSoundLevel, level);
    _maxSoundLevel = max(maxSoundLevel, level);

    level = level;

    notifyListeners();
  }
}