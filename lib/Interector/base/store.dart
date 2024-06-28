import 'package:flutter/material.dart';

enum LoadingState {
  none,
  initial,
  loading,
  loaded,
  error
}

class Store extends ChangeNotifier {
  showSuccessMessage(BuildContext context, String message) {
    var snackBar = _getSnackBar(message, success: true);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showErrorMessage(BuildContext context, String message) {
    var snackBar = _getSnackBar(message);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _getSnackBar(String message, {bool success = false}) {
    return SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        content: Text(message,style: const TextStyle(color: Colors.white),)
    );
  }
}