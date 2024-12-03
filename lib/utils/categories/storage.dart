import 'dart:convert';

import 'package:finance_tracker/utils/categories/bloc.dart';
import 'package:finance_tracker/utils/domain_layer/storage.dart';

typedef CategoryData = String;

class CategoryStorage {
  late CategoriesState _data;
  static const String _id = '__categories__';
  late InternalStorage _plugin;
  CategoryStorage({CategoriesState? data, required InternalStorage plugin}) {
    _data = data ?? CategoriesState(data: []);
    _plugin = plugin;
  }
  CategoriesState get data => _data;
  String get id => _id;
  Future<bool> add(CategoryData value) async {
    var exists = _data.data.indexOf(value);
    if (exists == -1) {
      _data.add(value);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> remove(CategoryData value) async {
    var exists = _data.data.indexOf(value);
    if (exists != -1) {
      _data.remove(value);
      return true;
    } else {
      return false;
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

  Future<void> saveData() async {
    var status = await _plugin.editValue(_id, toMap());
    print("STATUS in saveData $status");
    if (!status) {
      print('ADD VALUE in CategoryStorage');
      print('DATA BEFORE: ${_plugin.data}');
      _plugin.addValue(toMap());
      print('ADD VALUE in CategoryStorage');
      print('DATA AFTER: ${_plugin.data}');
    }
    await _plugin.saveStore();
  }

  Future<void> loadData() async {
    final ob = await _plugin.loadStore(_id);
    if (ob['value'] != null) {
      await setData(_data.copyWith(data: ob['value']));
    } else {
      Error();
    }
  }
}
