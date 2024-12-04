import 'package:finance_tracker/layout/nav_bar/nav_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NavBar extends StatefulWidget {
  NavBar(
      {super.key,
      required this.items,
      this.onChange,
      required this.onActionPressed});
  final List<NavBarItem> items;
  void Function(int)? onChange;
  final void Function() onActionPressed;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void _handleTap(int index) {
    return widget.onChange != null ? widget.onChange!(index) : () {};
  }

  int index = 0;
  int _innerIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<List<String>> itemKeys = [
      ['Queries', 'Accounts'],
      ['Charts', 'Settings']
    ];
    double gapSize = 90;
    double navGroupWidth = (MediaQuery.of(context).size.width - gapSize) / 2;
    return SizedBox(
      height: 116,
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 85,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(top: BorderSide(color: Colors.black, width: 2)),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(2, (i) {
                    List<Widget> chunks = [];
                    for (var j = 0; j < 2; j++) {
                      setState(() => _innerIndex = j + (i == 1 ? 2 : 0));
                      var chunk = Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            key: Key(itemKeys[i][j]),
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                iconColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer;
                                  }
                                  return Colors.black;
                                })),
                            isSelected: index == _innerIndex,
                            onPressed: () {
                              setState(() {
                                index = j + (i == 1 ? 2 : 0);
                              });
                              widget.items[j + (i == 1 ? 2 : 0)].onPressed();
                              _handleTap(index);
                            },
                            icon: widget.items[_innerIndex].icon,
                          ),
                          AnimatedSize(
                              duration: Durations.short4,
                              curve: Curves.easeInOut,
                              child: SizedBox(
                                height: index == _innerIndex ? 20 : 0,
                                child:
                                    Text(widget.items[_innerIndex].label ?? ''),
                              )),
                        ],
                      );
                      chunks.add(chunk);
                    }
                    return SizedBox(
                      width: navGroupWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: chunks,
                      ),
                    );
                  })),
            ),
          ),
          Positioned(
              top: 0,
              left: (MediaQuery.of(context).size.width / 2) - 32,
              child: Transform.rotate(
                angle: 0.785398,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(color: Colors.black, width: 2)),
                  child: IconButton(
                      style: IconButton.styleFrom(
                        fixedSize: const Size(double.infinity, double.infinity),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      onPressed: widget.onActionPressed,
                      icon: Transform.rotate(
                          angle: 0.785398, child: Icon(MdiIcons.plus))),
                ),
              )),
        ],
      ),
    );
  }
}
