import 'dart:convert';

import 'package:finance_tracker/utils/event_handling/done.dart';
import 'package:finance_tracker/utils/event_handling/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * Strucure of Storage
 * name: __storage__
 * data: {
 *  categories: [
 *    
 *  ]
 * }
 *
 *
 *
 */

abstract class InternalStorageAPI {
  InternalStorageAPI();

  Future<void> saveStore();
  Future<Map<String, dynamic>> loadStore(String name);
  Future<String> toJson(Map<String, dynamic> data);
  Future<Map<String, dynamic>> fromJson(String data);
  Future<BlocEvent> editValue(String name, Map<String, dynamic> data);
  Future<BlocEvent> addValue(Map<String, dynamic> data);
}

class InternalStorage extends InternalStorageAPI {
  late final SharedPreferencesWithCache _plugin;
  late Map<String, dynamic> _lastRemoved;
  late List<Map<String, dynamic>> _data = [];
  static String kStorage = '__storage__';
  InternalStorage(SharedPreferencesWithCache plugin) : _plugin = plugin {
    final ob = _plugin.getStringList(kStorage);
    if (_data.isEmpty && ob != null) {
      for (var s in ob) {
        final ob_ = json.decode(s) as Map<String, dynamic>;
        _data.add(ob_);
      }
    }
  }
  List<Map<String, dynamic>> get data => _data;

  @override
  Future<String> toJson(Map<String, dynamic> data) async {
    final ob = json.encode(data);
    return ob;
  }

  @override
  Future<Map<String, dynamic>> fromJson(String data) async {
    final ob = await json.decode(data) as Map<String, dynamic>;
    return ob;
  }

  @override
  Future<Map<String, dynamic>> loadStore(String name) async {
    final loaded = _plugin.getStringList(kStorage);
    if (loaded != null) {
      _data = [];
      for (var data in loaded) {
        final Map<String, dynamic> storage = await fromJson(data);
        _data.add(storage);
      }
      final ob = _data.indexWhere((e) => e['name'] == name);
      return _data[ob];
    }
    return {'name': name, 'value': null};
  }

  @override
  Future<BlocEvent> saveStore() async {
    try {
      List<String> savedData = [];
      List<String> names = List<String>.from(_data.map((e) => e['name']));
      names = names.toSet().toList();
      for (var name in names) {
        final encoded = await toJson(_data.lastWhere((e) => e['name'] == name));
        savedData.add(encoded);
      }
      _plugin.setStringList(kStorage, savedData);
      return const BlocDone('Data is saved');
    } catch (e, stack) {
      return BlocError('FAILURE: Data is not saved', err: e, stack: stack);
    }
  }

  /// Change Whole Data
  /// if it is not exists that mean that it is not stored yet
  @override
  Future<BlocEvent> editValue(String name, Map<String, dynamic> newData) async {
    var i = _data.indexWhere((e) => e['name'] == name);
    try {
      _data.removeAt(i);
      _data.add(newData);
      _data = _data.toSet().toList();
      saveStore();
      return BlocDone('SUCCESS: Edited $name repo');
    } catch (e, stack) {
      return BlocError('FAILURE: $name repo is not found',
          err: e, stack: stack);
    }
  }

  ///
  ///
  /// data will be like this
  /// "storage": [
  ///   {
  ///     'name': 'categories',
  ///     'value': ['a', 'b', 'c']
  ///   },
  ///   {
  ///     'name': 'tracks',
  ///     'value': ['a', 'b', 'c']
  ///   },,
  ///
  /// ]
  ///
  ///
  ///

  @override
  Future<BlocEvent> addValue(Map<String, dynamic> data) async {
    try {
      _data.add(data);
      _data = _data.toSet().toList();
      return const BlocDone('SUCCESS: Added data to InternalStorage');
    } catch (e, stack) {
      return BlocError('FAILURE: Adding $data in InternalStorage',
          err: e, stack: stack);
    }
  }
}
