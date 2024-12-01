import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DropMenu extends StatefulWidget {
  const DropMenu({super.key});

  @override
  State<DropMenu> createState() => _DropMenu();
}

class _DropMenu extends State<DropMenu> {
  final OverlayPortalController _controller = OverlayPortalController();

  bool isSelectedCategoryMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) => const Positioned(
        child: Align(
            alignment: AlignmentDirectional.topCenter, child: MenuWidget()),
      ),
      child: TextButton(
          onPressed: () => _controller.toggle(),
          child: Row(
            children: [
              const Text(''),
              IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      isSelectedCategoryMenuOpen = !isSelectedCategoryMenuOpen;
                    });
                  },
                  isSelected: isSelectedCategoryMenuOpen,
                  visualDensity: VisualDensity.compact,
                  highlightColor:
                      Color.alphaBlend(Colors.white70, Colors.black),
                  selectedIcon: Icon(
                    MdiIcons.chevronUp,
                    color: Colors.black,
                    size: 24,
                    opticalSize: 24,
                  ),
                  icon: Icon(
                    MdiIcons.chevronDown,
                    size: 24,
                    opticalSize: 24,
                  )),
              const Text(
                'Over All',
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 28,
                    fontWeight: FontWeight.w300),
              ),
            ],
          )),
    );
  }
}

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: ShapeDecoration(
          color: Colors.black26,
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1.5, color: Colors.black26),
              borderRadius: BorderRadius.circular(12)),
          shadows: const [
            BoxShadow(
                color: Color(0x11000000),
                blurRadius: 32,
                offset: Offset(0, 20),
                spreadRadius: -8)
          ]),
    );
  }
}
