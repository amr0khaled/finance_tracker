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
  List<bool> isSelected = List.generate(4, (i) => i == 0 ? true : false);
  int manySelected = 3;
  void doFilter(BuildContext context, List<TrackCategory> categories) {
    final bloc = context.read<TrackCollectionBloc>();
    bloc.add(TrackCollectionFilteringCategoryEvent(categories));
  }

  @override
  void initState() {
    super.initState();
    filter.addAll(TrackCategory.values);
  }

  @override
  Widget build(BuildContext context) {
    final filterNames = ['All', 'Personal', 'Work', 'Home'];
    return BlocBuilder<TrackCollectionBloc, TrackCollectionState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (i) {
              return IconButton(
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
                    filterNames[i],
                  ),
                ),
                isSelected: isSelected[i],
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.tertiary;
                  }
                  return Theme.of(context).colorScheme.secondary;
                })),
                onPressed: () {
                  setState(() {
                    isSelected[i] = !isSelected[i];
                    if (!isSelected[i]) {
                      manySelected++;
                    } else {
                      manySelected--;
                    }
                    if (i == 0) {
                      List<bool> newList = List.filled(4, false);
                      newList[0] = true;
                      isSelected = newList;
                      filter = TrackCategory.values;
                    } else {
                      if (isSelected.where((e) => e == false).length > 3) {
                        isSelected[i] = true;
                      }
                      isSelected[0] = false;
                    }
                    if (isSelected[0] == true && i != 0) {
                      isSelected[0] = false;
                    }
                    if (manySelected > 3) {
                      isSelected[i] = true;
                      manySelected = 3;
                    }
                    if (manySelected < 1) {
                      isSelected[i] = true;
                    }
                    List<TrackCategory> result = [];
                    if (isSelected.indexOf(true) != 0 &&
                        isSelected.lastIndexOf(true) > 0) {
                      for (var i = 0; i < isSelected.length; i++) {
                        if (isSelected[i]) {
                          switch (i) {
                            case 1:
                              {
                                result.add(TrackCategory.personal);
                              }
                            case 2:
                              {
                                result.add(TrackCategory.work);
                              }
                            default:
                              {
                                result.add(TrackCategory.home);
                              }
                          }
                        }
                      }
                    } else {
                      result = TrackCategory.values;
                    }
                    filter = result;
                    doFilter(context, result);
                  });
                },
              );
            }),
          ),
        ),
      );
    });
  }
}
