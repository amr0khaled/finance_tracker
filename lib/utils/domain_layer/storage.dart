import 'dart:convert';

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
  Future<bool> editValue(String name, Map<String, dynamic> data);
  Future<void> addValue(Map<String, dynamic> data);
}

class InternalStorage extends InternalStorageAPI {
  late final SharedPreferences _plugin;
  late Map<String, dynamic> _lastRemoved;
  @override
  late List<Map<String, dynamic>> _data = [];
  static String kStorage = '__storage__';
  InternalStorage(SharedPreferences plugin) : _plugin = plugin;
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
      for (var data in _data) {
        print(data['name']);
      }
      print('IndexWhere in loadStore $ob');
      return _data[ob];
    }
    return {'name': name, 'value': null};
  }

  @override
  Future<void> saveStore() async {
    List<String> savedData = [];
    List<String> names = List<String>.from(_data.map((e) => e['name']));
    names = names.toSet().toList();

    for (var name in names) {
      print('LOOPING: $data');
      final encoded = await toJson(_data.lastWhere((e) => e['name'] == name));
      savedData.add(encoded);
    }
    _plugin.setStringList(kStorage, savedData);
  }

  /// Change Whole Data
  /// if it is not exists that mean that it is not stored yet
  @override
  Future<bool> editValue(String name, Map<String, dynamic> newData) async {
    var status = _data.indexWhere((e) => e['name'] == name);
    if (status != -1) {
      _lastRemoved = _data.removeAt(status);
      _data.add(newData);
      _data = _data.toSet().toList();
      return true;
    } else {
      print('IS Already removed in EDIT');
      return false;
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
  Future<void> addValue(Map<String, dynamic> data) async {
    _data.add(data);
    _data = _data.toSet().toList();
    print('ADDED data in Add Value');
  }
}
