import 'dart:convert';

import 'package:educarte/Interactor/models/legal_guardians_model.dart';
import 'package:educarte/Interactor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Services/interfaces/persistence_interface.dart';
import '../../Services/repositories/persistence_repository.dart';
import '../../core/base/store.dart';
import '../../core/config/api_config.dart';
import '../../core/enum/persistence_enum.dart';
import '../../Ui/global/global.dart' as globals;
import '../../core/enum/request_type.dart';

class AuthProvider extends Store{
  final IPersistence persistenceInterface;
  AuthProvider(this.persistenceInterface);
  
  bool loading = false;

  void setLoading(bool value){
    loading = value;

    notifyListeners();
  }
  
  Future<void> login({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController
  }) async {
    setLoading(true);

    var response = await ApiConfig.request(
      url: "/Auth",
      requestType: RequestType.post,
      headers: {
        "Content-Type": "application/json",
      },
      body: {
        "email": emailController.text, 
        "password": passwordController.text
      }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jsonData["token"]);

      await persistenceInterface.update(
        key: SecureKey.token, 
        value: jsonData["token"]
      );

      final userProvider = GetIt.instance.get<UserProvider>();

      decodedToken["profile"] = globals.checkUserType(profileType: decodedToken["profile"]);
      userProvider.currentLegalGuardian = LegalGuardian.fromJson(decodedToken);
      userProvider.currentLegalGuardian.id = decodedToken["sub"];

      bool firstAccess = bool.parse(decodedToken["isFirstAccess"].toString().toLowerCase());

      String path = globals.routerPath(firstAccess: firstAccess);

      loading = false;

      if (firstAccess) {
        globals.firstAccess = firstAccess;
        
        return context.go(path);
      }
      if (path == "/home") {}

      return context.go(path);
    } else {
      showErrorMessage(context, "Credenciais Inválidas!");
    }

    setLoading(false);
  }

  Future<void> logout({
    required BuildContext context
  })async{
    PersistenceRepository persistenceRepository = PersistenceRepository();

    await persistenceRepository.delete(key: SecureKey.token);

    if(context.mounted){
      context.go("/login");
    }
  }

  Future<String?> refreshToken({
    required BuildContext context,
    required String token,
    required PersistenceRepository persistenceRepository
  }) async{
    String? path;

    var response = await ApiConfig.request(
      url: "/Auth/refresh",
      requestType: RequestType.post,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      }
    );

    try {
      if (response.statusCode == 200) {
        await persistenceRepository.update(
          key: SecureKey.token,
          value: jsonDecode(response.body)["token"]
        );

        Map<String, dynamic> decodedToken = JwtDecoder.decode(jsonDecode(response.body)["token"]);

        final userProvider = GetIt.instance.get<UserProvider>();

        decodedToken["profile"] = globals.checkUserType(profileType: decodedToken["profile"]);
        userProvider.currentLegalGuardian = LegalGuardian.fromJson(decodedToken);
        userProvider.currentLegalGuardian.id = decodedToken["sub"];

        bool firstAccess = bool.parse(decodedToken["isFirstAccess"].toLowerCase());
        globals.firstAccess = firstAccess;

        if (globals.nome == null) {
          // currentIndex = 2;
          path = globals.routerPath(firstAccess: firstAccess);
        }
      } else if (response.statusCode == 401) {
        await persistenceRepository.delete(key: SecureKey.token);
        globals.firstAccess = false;

        path = '/login';
      }
    } catch (e) {
      await persistenceRepository.delete(key: SecureKey.token);
      globals.firstAccess = false;

      path = '/login';
    }

    return path;
  }
}