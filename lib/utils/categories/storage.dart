import 'dart:convert';

import 'package:finance_tracker/utils/categories/bloc.dart';
import 'package:finance_tracker/utils/domain_layer/storage.dart';
import 'package:finance_tracker/utils/event_handling/done.dart';
import 'package:finance_tracker/utils/event_handling/error.dart';

typedef CategoryData = String;

class CategoryStorage {
  late CategoriesState _data;
  static const String _id = '__categories__';
  late InternalStorage _plugin;
  CategoryStorage({CategoriesState? data, required InternalStorage plugin}) {
    _data = data ?? CategoriesState(data: []);
    _plugin = plugin;
  }

  ///
  /// {index: 0, value: 'Home'}
  ///
  late Map<String, dynamic> _lastRemoved = {'index': -1, 'value': null};
  CategoriesState get data => _data;
  String get id => _id;
  Future<BlocEvent> add(CategoryData value) async {
    var exists = _data.data.indexOf(value);
    if (exists == -1) {
      _data.add(value);
      saveData();
      return BlocDone('SUCCESS: $value is added');
    } else {
      return BlocError('$value is already exists');
    }
  }

  Future<BlocEvent> remove(CategoryData value) async {
    var exists = _data.data.indexOf(value);
    if (exists != -1) {
      _data.remove(value);
      _lastRemoved = {'index': exists, 'value': value};
      saveData();
      return BlocDone('SUCCESS: $value is removed');
    } else {
      return BlocError('$value is not found');
    }
  }

  Future<BlocEvent> undo() async {
    if (_lastRemoved['value'] != null) {
      _data.insert(_lastRemoved['index'], _lastRemoved['value']);
      saveData();
      return BlocEvent('SUCCESS: ${_lastRemoved['value']} has return');
    } else {
      return BlocError('FAILURE: Nothing have been removed');
    }
  }

  Map<String, dynamic> toMap() {
    return {'name': _id, 'value': _data.data};
  }

  CategoriesState toClass(String data) {
    final ob = List<String>.from(json.decode(data) as List);
    return CategoriesState(data: ob, status: CategoryStatus.initial);
  }

  Future<void> setData(CategoriesState newData) async {
    _data = newData;
    saveData();
  }

  Future<BlocEvent> saveData() async {
    var status = await _plugin.editValue(_id, toMap());
    if (status is BlocError) {
      _plugin.addValue(toMap());
    }
    return await _plugin.saveStore();
  }

  Future<CategoriesState> loadData() async {
    final ob = await _plugin.loadStore(_id);
    late CategoriesState newState;
    if (ob['value'] != null) {
      newState = _data.copyWith(
          data: List<String>.from(ob['value']),
          event: const BlocDone('Data is loaded'));

      await setData(newState);
    } else {
      newState = _data
          .copyWith(data: <String>[], event: BlocError('Data is not found'));
      await setData(newState);
    }
    return newState;
  }
}
