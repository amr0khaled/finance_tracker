// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:finance_tracker/utils/categories/storage.dart';
import 'package:finance_tracker/utils/domain_layer/storage.dart';
import 'package:finance_tracker/utils/event_handling/done.dart';
import 'package:finance_tracker/utils/event_handling/error.dart';
import 'package:finance_tracker/utils/transaction/bloc.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

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
      int? amount,
      Contact? contact}) async {
    late BlocEvent event;
    late BlocEvent saveEvent;
    try {
      event = await _data.edit(transaction,
          title: title,
          desc: desc,
          categories: categories,
          date: date,
          amount: amount,
          contact: contact);
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

  String toJson(List<Transaction> data) {
    String ob = '';
    List<String> obs = [];
    for (var trans in data) {
      final ob_ = json.encode({
        'title': trans.title,
        'description': trans.desc,
        'categories': trans.categories,
        'amount': trans.amount,
        'date': trans.date,
        'contact': {
          'name': '',
          'phone_numbers': ['']
        }
      });
      obs.add(ob_);
    }
    ob = json.encode(obs);
    return ob;
  }

  List<Transaction> fromJson(String data) {
    List<Transaction> ob = [];
    var data_ = List<String>.from(json.decode(data) as List);
    for (var _trans in data_) {
      var trans = json.decode(_trans);

      var ob_ = Transaction(
          title: trans['title'],
          date: trans['date'],
          amount: trans['amount'],
          categories: List<String>.from(trans['categories'] as List),
          desc: trans['description'],
          contact: Contact(
              fullName: trans['contact']['name'],
              phoneNumbers: List<String>.from(
                  trans['contact']['phone_numbers'] as List)));
      ob.add(ob_);
    }
    return ob;
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
    print(ob['value']);
    if (ob['value'] != null) {
      newState = _data.copyWith(
          data: fromJson(ob['value']), event: const BlocDone('Data is loaded'));

      await setData(newState);
    } else {
      newState = _data.copyWith(
          data: <Transaction>[], event: BlocError('Data is not found'));
      await setData(newState);
    }
    return newState;
  }

  Map<String, dynamic> toMap() {
    return {'name': _id, 'value': toJson(_data.data)};
  }
}
