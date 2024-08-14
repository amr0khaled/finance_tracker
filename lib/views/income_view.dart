import 'dart:math';

import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/track.dart';
import 'package:flutter/material.dart';

class IncomeView extends StatefulWidget {
  const IncomeView(this.data, {super.key});
  final List<TrackData> data;

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('true');
  }

  @override
  Widget build(BuildContext context) {
    print("IncomeView ${widget.data}");
    return ListView(
        children: List.generate(widget.data.length, (i) {
      final TrackCard card = TrackCard(widget.data[i]);
      if (i == 0) {
        return Padding(padding: const EdgeInsets.only(top: 12), child: card);
      }
      return card;
    }));
  }
}

Random random = Random.secure();
TrackCategory rand() {
  int select = random.nextInt(3);
  switch (select) {
    case 1:
      {
        return TrackCategory.personal;
      }
    case 2:
      {
        return TrackCategory.work;
      }
    default:
      {
        return TrackCategory.home;
      }
  }
}
