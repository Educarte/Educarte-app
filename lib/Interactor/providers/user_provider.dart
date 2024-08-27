import 'dart:convert';

import 'package:educarte/core/base/store.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:educarte/core/enum/request_type.dart';
import 'package:flutter/material.dart';

import '../../Services/repositories/persistence_repository.dart';
import '../../core/enum/persistence_enum.dart';
import '../models/legal_guardians_model.dart';

class UserProvider extends Store{
  bool loading = false;

  void setLoading(bool value){
    loading = value;

    notifyListeners();
  }

  LegalGuardian currentLegalGuardian = LegalGuardian.empty();

  Future<void> getMyData({
    required BuildContext context,
    required TextEditingController nomeController,
    required TextEditingController emailController,
    required TextEditingController? telefoneController
  }) async{
    setLoading(true);
    String errorMessage = "Erro ao buscar dados do usuário";

    try {
      var response = await ApiConfig.request(url: "/Users/Me");

      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);

        nomeController.text = jsonData["name"];
        emailController.text = jsonData["email"];
        if(jsonData["cellphone"] != null){
          telefoneController?.text = jsonData["cellphone"];
        }
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }

  Future<void> updateData({
    required BuildContext context,
    required TextEditingController nomeController,
    required TextEditingController emailController,
    required TextEditingController? telefoneController
  }) async{
    setLoading(true);

    String errorMessage = "Erro ao atualizar informações"; 

    try{
      final String? token = await PersistenceRepository().read(key: SecureKey.token);
      
      var response = await ApiConfig.request(
        url: "/Users/${currentLegalGuardian.id}",
        requestType: RequestType.put,
        body: {
          "name": nomeController.text,
          "email": emailController.text,
          "cellphone": telefoneController?.text
        },
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type":"application/json"
        }
      );

      if(response.statusCode == 200){
        currentLegalGuardian = LegalGuardian.fromJson(jsonDecode(response.body));
      }else{
        Store().showErrorMessage(context, errorMessage);
      }
    }catch(e){
      Store().showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }
}