import 'dart:math';

import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeView extends StatelessWidget {
  const IncomeView(this.data, {super.key});
  final List<TrackState> data;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCollectionBloc, TrackCollectionState>(
        builder: (context, state) {
      final bloc = context.watch<TrackCollectionBloc>();
      print('bloc: ${bloc.state.status}');
      print('state: ${state.status}');
      return ListView(
          children: List.generate(state.data.length, (i) {
        final TrackCard card = TrackCard(state.data[i]);
        if (i == 0) {
          return Padding(padding: const EdgeInsets.only(top: 12), child: card);
        }
        return card;
      }));
    });
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
