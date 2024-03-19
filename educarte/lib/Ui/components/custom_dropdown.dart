import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key, 
    required this.list, 
    this.callback, 
    required this.selected
  });
  final List<String> list;
  final String selected;
  final Function(String result)? callback;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}