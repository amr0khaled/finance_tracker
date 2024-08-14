import 'package:finance_tracker/main.dart';
import 'package:finance_tracker/utils/track.dart';
import 'package:flutter/material.dart';

List<TrackCategory> filter = [];

class FilterTracks extends StatefulWidget {
  const FilterTracks({super.key});

  @override
  State<FilterTracks> createState() => _FilterTracksState();
}

class _FilterTracksState extends State<FilterTracks> {
  List<bool> isSelected = List.generate(4, (i) => i == 0 ? true : false);
  int manySelected = 3;
  void doFilter() {
    setState(() {
      incomeData.clear();
      expenseData.clear();
      for (var i in data) {
        if (filter.contains(i.category)) {
          switch (i.type) {
            case TrackType.income:
              {
                incomeData.add(i);
                break;
              }
            default:
              {
                expenseData.add(i);
              }
          }
        }
        continue;
      }
      print(incomeData);
    });
  }

  @override
  void initState() {
    super.initState();
    filter.addAll(TrackCategory.values);
    doFilter();
  }

  @override
  Widget build(BuildContext context) {
    final filterNames = ['All', 'Personal', 'Work', 'Home'];
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) {
            return IconButton(
              icon: Text(
                filterNames[i],
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected[i]
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.onSecondary),
              ),
              isSelected: isSelected[i],
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
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
                  doFilter();
                });
              },
            );
          }),
        ),
      ),
    );
  }
}
