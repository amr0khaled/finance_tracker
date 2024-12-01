import 'package:flutter/material.dart';

class DrawerItem {
  const DrawerItem({required this.icon, required this.onTap});
  final Icon icon;
  final VoidCallback onTap;
}
