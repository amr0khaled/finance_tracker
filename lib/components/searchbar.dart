import 'package:finance_tracker/utils/tracks/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unicons/unicons.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TrackCollectionBloc>();

    Size screen = MediaQuery.sizeOf(context);
    double barSide = screen.width * 0.05;
    double barTop = 12;
    double barWidth = screen.width - (barSide * 2.05);
    Color bgColor = Theme.of(context).colorScheme.secondaryContainer;
    return SafeArea(
      child: Container(
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
                      onChanged: (value) {
                        bloc.add(TrackCollectionFilteringEvent(value));
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    )),
                // TODO: Add Acoount Image
                Container(
                  padding: const EdgeInsets.all(12),
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      style: ButtonStyle(
                          elevation: const WidgetStatePropertyAll(5),
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                          fixedSize:
                              const WidgetStatePropertyAll(Size(16, 16))),
                      onPressed: () {},
                      icon: Container()),
                )
              ]))),
    );
  }
}
