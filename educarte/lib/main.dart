import 'package:educarte/Services/config/provider/speech_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'Ui/screens/my_app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  DI.addServices();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context) => SpeechProvider())
      ],
      child: const MyApp()
    )
  );
}

class DI {
  static void addServices() {
    final services = GetIt.instance;

    services.registerSingleton(SpeechProvider());
  }
}

