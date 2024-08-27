import 'package:educarte/Interactor/providers/auth_provider.dart';
import 'package:educarte/Interactor/providers/menu_provider.dart';
import 'package:educarte/Interactor/providers/student_provider.dart';
import 'package:educarte/Interactor/providers/user_provider.dart';
import 'package:get_it/get_it.dart';

import '../../Interactor/providers/speech_provider.dart';
import '../../Services/repositories/persistence_repository.dart';
import '../../Services/interfaces/persistence_interface.dart';

class DI {
  static void addInjections() async {
    final services = GetIt.instance;
    

    services.registerSingleton<IPersistence>(PersistenceRepository());

    services.registerSingleton(AuthProvider(services.get<IPersistence>()));
    services.registerSingleton(StudentProvider());
    services.registerSingleton(UserProvider());
    services.registerSingleton(SpeechProvider());
    services.registerSingleton(MenuProvider());
  }
}