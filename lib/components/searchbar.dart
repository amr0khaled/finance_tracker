import 'package:flutter/material.dart';

import 'package:unicons/unicons.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    double barSide = screen.width * 0.05;
    double barTop = 12;
    double barWidth = screen.width - (barSide * 2.05);
    Color bgColor = Theme.of(context).colorScheme.secondaryContainer;
    return Container(
        key: const Key('SearchBarWidget Container'),
        margin: EdgeInsets.fromLTRB(barSide, barTop, barSide, 0),
        transformAlignment: Alignment.center,
        width: screen.width,
        height: 56.0,
        child: DecoratedBox(
            key: const Key('SearchBarWidget DecoratedBox'),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.all(Radius.circular(150))),
            child: Row(key: const Key('SearchBarWidget Row'), children: [
              const SizedBox(
                  width: 64,
                  // height: ,
                  child: Icon(
                    UniconsLine.search,
                    opticalSize: 24,
                  )),
              SizedBox(
                  width: barWidth - 64 - 64,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  )),
              // TODO: Add Acoount Image
              SizedBox(
                width: 64,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ])));
  }
}
