import 'dart:convert';

import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';

import '../../core/base/store.dart';
import '../models/document.dart';

class MenuProvider extends Store{
  bool loading = false;
  Document currentMenu = Document.empty();

  void setLoading(bool value){
    loading = value;

    notifyListeners();
  }

  Future<void> getMenu({
    required BuildContext context,
  }) async{
    setLoading(true);
    String errorMessage = "Erro ao buscar menu";
    
    try {
      var response = await ApiConfig.request(
        url: "/Menus"
      );

      if(response.statusCode == 200){
        Map<String,dynamic> decodeJson = jsonDecode(response.body);

        currentMenu = Document(id: decodeJson["items"][0]["id"].toString(),name: decodeJson["items"][0]["name"].toString(),fileUri: decodeJson["items"][0]["uri"].toString());
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }
}