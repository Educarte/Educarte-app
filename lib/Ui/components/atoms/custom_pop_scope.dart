import 'package:flutter/material.dart';

import '../../shell/educarte_shell.dart';

class CustomPopScope extends StatelessWidget {
  final Widget child;
  const CustomPopScope({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        selectedIndex.value = (previousIndex!.value == 4 || previousIndex!.value == 1) &&  selectedIndex.value != 2 ? 2 : previousIndex!.value;

        return;
      },
      child: child
    );
  }
}