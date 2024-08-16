import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  List<TrackState> data = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCollectionBloc, TrackCollectionState>(
        builder: (context, state) {
      if (data.isEmpty) {
        data = state.data.where((e) => e.type == TrackType.expense).toList();
      }
      if (state.status != TrackCreationStatus.initial) {
        data = state.data.where((e) => e.type == TrackType.expense).toList();
      }
      return ListView(
          children: List.generate(data.length, (i) {
        final TrackCard card = TrackCard(data[i]);
        if (i == 0) {
          return Padding(padding: const EdgeInsets.only(top: 12), child: card);
        }
        return card;
      }));
    });
  }
}
