import 'package:finance_tracker/layout/drawer/drawer_item.dart';
import 'package:flutter/material.dart';

class NewDrawer extends StatelessWidget {
  NewDrawer({super.key, required this.scaffoldKey, this.items = const []});
  final GlobalKey<ScaffoldState> scaffoldKey;
  List<DrawerItem> items;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        elevation: 2,
        type: MaterialType.transparency,
        shadowColor: Colors.red,
        child: Ink(
          width: 96,
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                left: 20,
                width: 66,
                height: 194,
                child: Container(
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return IconButton(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0))),
                              fixedSize:
                                  const WidgetStatePropertyAll(Size(64, 64))),
                          onPressed: () {
                            scaffoldKey.currentState!.closeDrawer();
                          },
                          icon: items[i].icon,
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
