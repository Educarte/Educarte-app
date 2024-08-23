import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/base/constants.dart';
import '../../Services/config/provider/speech_provider.dart';

class SearchByVoicePage extends StatefulWidget{
  const SearchByVoicePage({
    super.key,
    required this.controller,
    required this.context
  });
  final TextEditingController controller;
  final BuildContext context;

  @override
  State<SearchByVoicePage> createState() => _SearchByVoicePageState();
}

class _SearchByVoicePageState extends State<SearchByVoicePage> {
  final speechProvider = GetIt.instance.get<SpeechProvider>();
  final SpeechToText speech = SpeechToText();
  
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String _currentLocaleId = '';

  @override
  void initState() {
    if(!_hasSpeech) initSpeechState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(widget.context).background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            speech.cancel();

            context.pop();
          },
          child: Icon(
            Icons.close,
            size: 32,
            color: colorScheme(widget.context).outline,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: speechProvider,
        builder: (_, child) {
          return Column(
            children: [
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      speechProvider.status == SpeechProviderState.started ? "Ouvindo..." : "",
                      style: textTheme(widget.context).titleMedium!.copyWith(
                        color: colorScheme(widget.context).outline,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      speechProvider.status == SpeechProviderState.error ? "Nao consegui ouvir. Tente novamente." : "",
                      style: textTheme(widget.context).titleSmall!.copyWith(
                        color: colorScheme(widget.context).outline,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async => !_hasSpeech || speechProvider.status == SpeechProviderState.started ? null : await checkMicrophone(),
                        splashFactory: NoSplash.splashFactory,
                        child: Container(
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: .26,
                                spreadRadius: level * 1.5,
                                color: colorScheme(widget.context).outline.withOpacity(.05)
                              )
                            ],
                            color: colorScheme(widget.context).error.withOpacity(speechProvider.status == SpeechProviderState.started ? 0.5 : 1),
                            borderRadius: BorderRadius.circular(48)
                          ),
                          child: Icon(
                            speechProvider.status == SpeechProviderState.started ? Symbols.mic_off : Symbols.mic,
                            size: 48,
                            color: colorScheme(widget.context).background
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        speechProvider.status == SpeechProviderState.error ? "Toque no microfone novamente" : "",
                        style: textTheme(widget.context).bodyLarge!.copyWith(
                          color: colorScheme(widget.context).outline,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ]
                  ),
                ),
              ),
            ]
          );
        },
      )
    );
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
      );

      if (hasSpeech) {
        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });

      await checkMicrophone();
    } catch (e) {
      setState(() {
        _hasSpeech = false;
      });
    }
    
  }

  void startListening() {
    speechProvider.changeStatus(receivedStatus: SpeechProviderState.started);

    speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation
    );
  }

  void resultListener(SpeechRecognitionResult result) {
    if(result.finalResult && result.alternates.first.recognizedWords.isNotEmpty){
      widget.controller.text = result.recognizedWords;

      speechProvider.changeStatus(receivedStatus: SpeechProviderState.finish);
      context.pop();
    }
  }

  void errorListener(SpeechRecognitionError error) {
    if(error.errorMsg == "error_no_match" || error.errorMsg == "error_speech_timeout" || error.errorMsg == "error_network"){
      speechProvider.changeStatus(receivedStatus: SpeechProviderState.error);
    }
  }

  void statusListener(String status) {
    if(status == "done"){
      speechProvider.changeStatus(receivedStatus: SpeechProviderState.done);
    }
  }

  void stopListening() {
    speech.stop();
    
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();

    setState(() {
      level = 0.0;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);

    setState(() {
      this.level = level;
    });
  }

  Future checkMicrophone() async{
    if(await Permission.microphone.isDenied || await Permission.microphone.isPermanentlyDenied){
      await Permission.microphone.request().then((permission) {
        if(permission == PermissionStatus.granted){
          startListening();
        }
      });
    }else{
      startListening();
    }
  }
}