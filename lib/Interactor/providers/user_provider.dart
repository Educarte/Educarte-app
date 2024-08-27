import 'package:educarte/core/base/store.dart';
import 'package:flutter/material.dart';

import '../models/legal_guardians_model.dart';

class UserProvider extends Store{
  bool loading = false;

  void setLoading(bool value){
    loading = value;

    notifyListeners();
  }

  LegalGuardian currentLegalGuardian = LegalGuardian.empty();

  Future<void> getLegalGuardianData({
    required BuildContext context,
    required Function getMenu
  }) async{
    setLoading(true);

    getMenu.call();

    
  }
}