import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeView extends StatefulWidget {
  const IncomeView({super.key});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

List<TrackState> data = [];

class _IncomeViewState extends State<IncomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCollectionBloc, TrackCollectionState>(
        builder: (context, state) {
      if (data.isEmpty) {
        data = state.data.where((e) => e.type == TrackType.income).toList();
      }
      if (state.status != TrackCreationStatus.initial) {
        data = state.data.where((e) => e.type == TrackType.income).toList();
      }
      return ListView(
          children: List.generate(data.length, (i) {
        print(data);
        final TrackCard card = TrackCard(data[i]);
        if (i == 0) {
          return Padding(padding: const EdgeInsets.only(top: 12), child: card);
        }
        return card;
      }));
    });
  }
}
