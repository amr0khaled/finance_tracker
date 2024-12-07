import 'dart:convert';

import 'package:finance_tracker/components/popup_transaction.dart';
import 'package:finance_tracker/utils/categories/storage.dart';
import 'package:finance_tracker/utils/transaction/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubTask {
  SubTask({required this.title, this.value});
  final String title;
  bool? value = false;
  void set(void Function(void Function()) _setState, bool? v) {
    _setState(() => value = v);
  }

  setValue(bool? v) {
    value = v;
    print(value);
  }
}

SubTask _toSubTask(String data) {
  final decoded = json.decode(data) as Map<String, dynamic>;
  return SubTask(title: decoded['title'], value: decoded['value']);
}

String _fromSubTask(SubTask data) {
  final ob = {'title': data.title, 'value': data.value};
  return json.encode(ob);
}

class QueriesView extends StatefulWidget {
  const QueriesView({super.key});

  @override
  State<QueriesView> createState() => _QueriesViewState();
}

class _QueriesViewState extends State<QueriesView> {
  bool main = false;
  List<SubTask> vv =
      List.generate(4, (i) => SubTask(title: 'Item No23131231', value: false));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: Text(
            'TODOs',
            style: TextStyle(
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400),
          ),
        ),
        _buildTaskItem(
            context, 'Grocories from Convenient Store', 4404, vv, main, (v) {
          setState(() {
            main = v ?? false;
            if (main == true) {}
          });
          for (var i in vv) {
            i.set(setState, main);
          }
        }, true),
        // _TodoSection()

        BlocProvider<TransactionsBloc>.value(
            value: BlocProvider.of<TransactionsBloc>(context),
            child: const RecentTrans())
      ],
    ));
  }

  Widget _buildTaskItem(
      BuildContext context,
      String title,
      int amount,
      List<SubTask>? subtasks,
      bool done,
      void Function(bool?)? changeBool,
      bool lastItem) {
    Size screen = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      value: done,
                      splashRadius: 14,
                      side: const BorderSide(
                        width: 1,
                      ),
                      onChanged: changeBool,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              if (amount != 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: amount > 0
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${amount > 0 ? "" : '-'}\$${amount < 0 ? (amount * -1).toString() : amount.toString()}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: amount > 0
                            ? Color.alphaBlend(Colors.black54,
                                Theme.of(context).colorScheme.primary)
                            : Color.alphaBlend(Colors.black54,
                                Theme.of(context).colorScheme.error)),
                  ),
                ),
            ],
          ),
          if (subtasks != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: subtasks
                    .map(
                      (subtask) => Container(
                        constraints:
                            BoxConstraints(maxWidth: screen.width * 0.28),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                visualDensity: const VisualDensity(
                                  horizontal: -2,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: subtask.value ?? false,
                                splashRadius: 14,
                                side: const BorderSide(
                                  width: 1,
                                ),
                                onChanged: (v) => subtask.set(setState, v),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                subtask.title,
                                style: TextStyle(
                                  decoration: subtask.value == true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationThickness: 2,
                                  fontSize: 14,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          if (!lastItem) const Divider(),
        ],
      ),
    );
  }
}

class RecentTrans extends StatefulWidget {
  const RecentTrans({super.key});

  @override
  State<RecentTrans> createState() => _RecentTransState();
}

class _RecentTransState extends State<RecentTrans> {
  List<bool> descriptions = List.filled(2, false);
  void changeBool(int i) {
    setState(() {
      descriptions[i] = !descriptions[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BlocBuilder<TransactionsBloc, Transactions>(
          bloc: BlocProvider.of<TransactionsBloc>(context),
          builder: (context, state) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  for (var trans in state.data)
                    _buildTransactionItem(context, trans.title, trans.amount,
                        date: trans.date,
                        categories: trans.categories,
                        description: trans.desc,
                        lastItem: trans == state.data.last)
                ]);
          }
          // _buildTransactionItem(
          //   context,
          //   'Salary',
          //   4000,
          //   description: "Salary of the month",
          //   lastItem: false,
          // ),
          ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, String title, int amount,
      {bool lastItem = false,
      String? description,
      required String date,
      required List<CategoryData> categories}) {
    Size screen = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (description != null) {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (context, a, b) {
                      return PopupTransaction(
                        title: title,
                        description: description,
                      );
                    });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                if (amount != 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: amount > 0
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${amount > 0 ? "" : '-'}\$${amount < 0 ? (amount * -1).toString() : amount.toString()}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: amount > 0
                              ? Color.alphaBlend(Colors.black54,
                                  Theme.of(context).colorScheme.primary)
                              : Color.alphaBlend(Colors.black54,
                                  Theme.of(context).colorScheme.error)),
                    ),
                  ),
              ],
            ),
          ),
          if (!lastItem) const Divider(),
        ],
      ),
    );
  }
}
