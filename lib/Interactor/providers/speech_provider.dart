import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum SpeechProviderState { init, started, done, error, finish }

class SpeechProvider extends ChangeNotifier {
  SpeechProviderState _status = SpeechProviderState.init;
  SpeechProviderState get status => _status;

  final SpeechToText speech = SpeechToText();
  late BuildContext currentContext;
  late TextEditingController controller;

  void changeStatus({required SpeechProviderState receivedStatus}) {
    _status = receivedStatus;

    notifyListeners();
  }
}