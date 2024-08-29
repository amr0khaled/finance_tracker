import 'package:flutter/material.dart';

class ViewBootStrap extends StatelessWidget {
  const ViewBootStrap(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: child,
    ));
  }
}
