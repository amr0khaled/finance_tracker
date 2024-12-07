// ignore_for_file: prefer_final_fields

import 'package:finance_tracker/utils/categories/storage.dart';
import 'package:finance_tracker/utils/domain_layer/storage.dart';
import 'package:finance_tracker/utils/event_handling/done.dart';
import 'package:finance_tracker/utils/event_handling/error.dart';
import 'package:finance_tracker/utils/transaction/bloc.dart';

class TransactionsStorage {
  late InternalStorage _plugin;
  late Transactions _data;
  final String _id = '__transactions__';
  TransactionsStorage({required InternalStorage plugin, Transactions? data}) {
    _data = data ?? Transactions(data: []);
    _plugin = plugin;
  }
  String get id => _id;
  Transactions get data => _data;
  // {index: -1, value: transaction}
  Map<String, dynamic> _lastRemoved = {'index': -1, 'value': null};

  Future<BlocEvent> add(Transaction transaction) async {
    late BlocEvent event;
    late BlocEvent saveEvent;
    try {
      event = await _data.add(transaction);
      if (event is BlocError) {
        throw Error();
      }
      saveEvent = await saveData();
      if (saveEvent is BlocError) {
        throw Error();
      }
      return event;
    } catch (e, s) {
      if (event is BlocError) {
        return BlocError(event.message, err: e, stack: s);
      }
      return BlocError(saveEvent.message, err: e, stack: s);
    }
  }

  Future<BlocEvent> remove(Transaction transaction) async {
    late BlocEvent event;
    late BlocEvent saveEvent;
    try {
      event = await _data.add(transaction);
      if (event is BlocError) {
        throw Error();
      }
      saveEvent = await saveData();
      if (saveEvent is BlocError) {
        throw Error();
      }
      return event;
    } catch (e, s) {
      if (event is BlocError) {
        return BlocError(event.message, err: e, stack: s);
      }
      return BlocError(saveEvent.message, err: e, stack: s);
    }
  }

  Future<BlocEvent> undo() async {
    late BlocEvent event;
    late BlocEvent saveEvent;
    try {
      event = await _data.insert(_lastRemoved['index'], _lastRemoved['value']);
      if (event is BlocError) {
        throw Error();
      }
      saveEvent = await saveData();
      if (saveEvent is BlocError) {
        throw Error();
      }
      return event;
    } catch (e, s) {
      if (event is BlocError) {
        return BlocError(event.message, err: e, stack: s);
      }
      return BlocError(saveEvent.message, err: e, stack: s);
    }
  }

  Future<BlocEvent> edit(Transaction transaction,
      {String? title,
      String? desc,
      List<CategoryData>? categories,
      String? date,
      int? amount}) async {
    late BlocEvent event;
    late BlocEvent saveEvent;
    try {
      event = await _data.edit(
        transaction,
        title: title,
        desc: desc,
        categories: categories,
        date: date,
        amount: amount,
      );
      if (event is BlocError) {
        throw Error();
      }
      saveEvent = await saveData();
      if (saveEvent is BlocError) {
        throw Error();
      }
      return event;
    } catch (e, s) {
      if (event is BlocError) {
        return BlocError(event.message, err: e, stack: s);
      }
      return BlocError(saveEvent.message, err: e, stack: s);
    }
  }

  Future<void> setData(Transactions newData) async {
    _data = newData;
    await saveData();
  }

  Future<BlocEvent> saveData() async {
    var status = await _plugin.editValue(_id, toMap());
    if (status is BlocError) {
      _plugin.addValue(toMap());
    }
    return await _plugin.saveStore();
  }

  Future<Transactions> loadData() async {
    final ob = await _plugin.loadStore(_id);
    late Transactions newState;
    if (ob['value'] != null) {
      newState = _data.copyWith(
          data: List<Transaction>.from(ob['value']),
          event: const BlocDone('Data is loaded'));

      await setData(newState);
    } else {
      newState = _data.copyWith(
          data: <Transaction>[], event: BlocError('Data is not found'));
      await setData(newState);
    }
    return newState;
  }

  Map<String, dynamic> toMap() {
    return {'name': _id, 'value': _data.data};
  }
}
