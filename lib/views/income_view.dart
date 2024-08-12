import 'dart:math';

import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/track.dart';
import 'package:flutter/material.dart';

class IncomeView extends StatelessWidget {
  const IncomeView(this.data, {super.key});
  final List<TrackData> data;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(data.length, (i) {
      final TrackCard card = TrackCard(data[i]);
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
