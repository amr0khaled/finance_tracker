import 'package:flutter/material.dart';

class NavBarItem {
  NavBarItem(
      {required this.onPressed,
      required this.icon,
      this.label,
      this.isSelected = false});
  final VoidCallback onPressed;
  final Icon icon;
  String? label;
  bool isSelected;
}
