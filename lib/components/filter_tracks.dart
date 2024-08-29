import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<TrackCategory> filter = [];

class FilterTracks extends StatefulWidget {
  const FilterTracks({super.key});

  @override
  State<FilterTracks> createState() => _FilterTracksState();
}

class _FilterTracksState extends State<FilterTracks> {
  List<String> categoriesNames = [];
  late List<bool> isSelected =
      List.generate(categoriesNames.length, (i) => i == 0 ? true : false);
  int manySelected = 3;
  void doFilter(BuildContext context, List<TrackCategory> categories) {
    final bloc = context.read<TrackCollectionBloc>();
    bloc.add(TrackCollectionFilteringCategoryEvent(categories));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<TrackCollectionBloc>(context);
    var state = bloc.state;

    final categories = state.getCategories();
    if (categoriesNames.isEmpty) {
      setState(() {
        categoriesNames.add('All');
        categoriesNames.addAll(categories.names.map((e) {
          var arr = e.split('').toList();
          arr[0] = e[0].toUpperCase();
          return arr.join();
        }).toList());
        filter = categories.values;
      });
    }
    print(isSelected);
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: categories.names.isEmpty
              ? []
              : List.generate(categories.names.length + 1, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      icon: AnimatedDefaultTextStyle(
                        duration: Durations.medium2,
                        curve: Curves.linearToEaseOut,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected[i]
                                ? Theme.of(context).colorScheme.onTertiary
                                : Theme.of(context).colorScheme.onSecondary),
                        child: Text(
                          categoriesNames[i],
                        ),
                      ),
                      isSelected: isSelected[i],
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 16),
                      style: ButtonStyle(backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(context).colorScheme.tertiary;
                        }
                        return Theme.of(context).colorScheme.secondary;
                      })),
                      onPressed: () {
                        setState(() {
                          final values = categories.values;
                          isSelected[i] = !isSelected[i];
                          if (!isSelected[i]) {
                            manySelected++;
                          } else {
                            manySelected--;
                          }
                          if (i == 0) {
                            List<bool> newList =
                                List.filled(isSelected.length, false);
                            newList[0] = true;
                            isSelected = newList;
                            filter = values;
                          } else {
                            if (isSelected.where((e) => e == false).length >
                                categoriesNames.length - 1) {
                              isSelected[i] = true;
                            }
                            isSelected[0] = false;
                          }
                          if (isSelected[0] == true && i != 0) {
                            isSelected[0] = false;
                          }
                          if (manySelected > categoriesNames.length - 1) {
                            isSelected[i] = true;
                            manySelected = categoriesNames.length - 1;
                          }
                          if (manySelected < 1) {
                            isSelected[i] = true;
                          }
                          List<TrackCategory> result = [];
                          if (isSelected.indexOf(true) != 0 &&
                              isSelected.lastIndexOf(true) > 0) {
                            for (var i = 0; i < isSelected.length; i++) {
                              if (isSelected[i]) {
                                print(true);
                                result.add(values[i - 1]);
                              }
                            }
                          } else {
                            result = values;
                          }
                          print(result.map((e) => e.name));
                          filter = result;
                          doFilter(context, result);
                        });
                      },
                    ),
                  );
                }),
        ),
      ),
    );
  }
}
