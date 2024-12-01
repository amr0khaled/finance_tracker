import 'package:flutter/material.dart';

class OverlayMenu extends StatefulWidget {
  OverlayMenu({
    super.key,
    required this.items,
    this.itemsCount = 0,
    this.leadings = const [],
    this.trailings = const [],
    required this.onTap,
  });

  //final double top;
  //final double left;
  List<String> items;
  int itemsCount;
  List<Widget> leadings;
  List<Widget> trailings;
  VoidCallback onTap = () {};

  @override
  State<OverlayMenu> createState() => _OverlayMenuState();
}

class _OverlayMenuState extends State<OverlayMenu> {
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0,
        color: Colors.transparent,
        type: MaterialType.card,
        shadowColor: Colors.transparent,
        child: Ink(
            height: 104,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Container(
                width: double.infinity, height: 104, child: Text('Hello')))
        // ListView.builder(
        //     itemCount: widget.items.length,
        //     itemBuilder: (context, i) {
        //       return ListTile(
        //         title: Text(widget.items[i]),
        //         leading: widget.leadings[i],
        //         trailing: widget.trailings[i],
        //         onTap: widget.onTap,
        //       );
        //     }),
        );
  }
}
