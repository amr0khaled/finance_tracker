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
  Future<dynamic> loadStore(String name);
  Future<String> toJson(Map<String, dynamic> data);
  Future<Map<String, dynamic>> fromJson(String data);
  Future<bool> editValue(String name, Map<String, dynamic> data);
}

class InternalStorage extends InternalStorageAPI {
  late final SharedPreferences _plugin;
  late final List<Map<String, dynamic>> _data;
  late Map<String, dynamic> _lastRemoved;
  static String kStorage = '__storage__';
  InternalStorage(SharedPreferences plugin) : _plugin = plugin;

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
  Future<dynamic> loadStore(String name) async {
    final loaded = _plugin.getStringList(kStorage);
    if (loaded != null) {
      _data = [];
      for (var data in loaded) {
        final Map<String, dynamic> storage = await fromJson(data);
        _data.add(storage);
      }
      final ob = _data.firstWhere((e) => e['name'] == name);
      return ob;
    }
  }

  @override
  Future<void> saveStore() async {
    List<String> savedData = [];
    for (var data in _data) {
      final encoded = await toJson(data);
      savedData.add(encoded);
    }
    _plugin.setStringList(kStorage, savedData);
  }

  @override
  Future<bool> editValue(String name, Map<String, dynamic> data) async {
    _lastRemoved = _data.firstWhere((e) => e['name'] == name);
    if (_data.remove(_lastRemoved)) {
      _data.add(data);
      return true;
    } else {
      print('IS Already removed');
      return false;
    }
  }
}
