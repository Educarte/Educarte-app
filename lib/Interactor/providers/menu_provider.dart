import 'dart:convert';

import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      var params = {
        "StartDate": DateFormat.yMd().format(DateTime.now()).toString(),
        "EndDate": DateFormat.yMd().format(DateTime.now()).toString()
      };

      
      var response = await ApiConfig.request(
        customUri: Uri.parse("$apiUrl/Menus").replace(queryParameters: params)
      );

      if(response.statusCode == 200){
        Map<String,dynamic> decodeJson = jsonDecode(response.body);

        if((decodeJson["items"] as List).isEmpty){
          showErrorMessage(context, "Nenhum menu encontrado");
          selectedIndex.value = previousIndex!.value;
        }else{
          currentMenu = Document(id: decodeJson["items"][0]["id"].toString(),name: decodeJson["items"][0]["name"].toString(),fileUri: decodeJson["items"][0]["uri"].toString());
        }
      }else{
        showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      showErrorMessage(context, errorMessage);
    }

    setLoading(false);
  }
}