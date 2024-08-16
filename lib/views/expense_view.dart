import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:finance_tracker/views/income_view.dart';
import 'package:flutter/material.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  late List<Widget> cards;

  @override
  void initState() {
    super.initState();
    cards = List<Widget>.generate(10, (i) {
      i++;
      final TrackCard card = TrackCard(TrackState(
          title: 'Expense $i',
          value: 123,
          type: random.nextInt(2) == 1 ? TrackType.income : TrackType.expense,
          category: rand(),
          description: random.nextInt(2) == 1
              ? ''
              : '''
            This is a test description and i use it to develope the Ui i designed to put it on my portfolio
            '''));
      if (i == 0) {
        return Padding(padding: const EdgeInsets.only(top: 12), child: card);
      }
      return card;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cards,
    );
  }
}
