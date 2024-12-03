import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/utils/tracks/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildItem(BuildContext context, Animation<double> an, Offset offset,
    AnimationController parent, Widget child) {
  Animation<Offset> pos = Tween(begin: offset, end: const Offset(1.2, 0))
      .animate(CurvedAnimation(parent: parent, curve: Curves.linearToEaseOut));
  return SlideTransition(
    position: pos,
    child: child,
  );
}

late AnimationController listController;

class IncomeView extends StatefulWidget {
  const IncomeView({super.key});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

List<TrackState> data = [];

GlobalKey<AnimatedListState> incomeListKey = GlobalKey<AnimatedListState>();

class _IncomeViewState extends State<IncomeView> with TickerProviderStateMixin {
  int initIndex = 0;

  @override
  void initState() {
    super.initState();
    listController =
        AnimationController(duration: Durations.medium2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    listController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCollectionBloc, TrackCollectionState>(
        buildWhen: (p, n) =>
            p.data.length != n.data.length || p.status != n.status,
        builder: (context, state) {
          if (data.isEmpty) {
            data = state.data.where((e) => e.type == TrackType.income).toList();
            initIndex = data.length;
          }
          if (state.status != TrackCreationStatus.initial) {
            data = state.data.where((e) => e.type == TrackType.income).toList();
          }
          return data.isEmpty
              ? Container()
              : AnimatedList(
                  key: incomeListKey,
                  initialItemCount: data.length,
                  itemBuilder: (c, i, a) {
                    final TrackCard card = TrackCard(data[i], i);
                    if (i == 0) {
                      return Padding(
                          padding: const EdgeInsets.only(top: 12), child: card);
                    }
                    return buildItem(c, a, Offset.zero, listController, card);
                  });
          // return ListView(
          //     children: List.generate(data.length, (i) {
          //   final TrackCard card = TrackCard(data[i]);
          //   if (i == 0) {
          //     return Padding(
          //         padding: const EdgeInsets.only(top: 12), child: card);
          //   }
          //   return card;
          // }));
        });
  }
}
