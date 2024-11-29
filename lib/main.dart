import 'package:educarte/Interactor/providers/speech_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'Ui/screens/my_app.dart';
import 'core/config/dependencies_config.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  await FlutterDownloader.initialize(ignoreSsl: true);
  DI.addInjections();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context) => SpeechProvider())
      ],
      child: const MyApp()
    )
  );
}
