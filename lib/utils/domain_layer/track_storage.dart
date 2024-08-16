import 'dart:convert';

import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackStorage {
  late final SharedPreferences _plugin;
  TrackCollectionState? state;
  TrackStorage(SharedPreferences plugin, {this.state}) : _plugin = plugin {
    _init();
  }
  late final _tracks_collections_controller =
      BehaviorSubject<TrackCollectionState>.seeded(
          state ?? TrackCollectionState('not', data: const []));
  static const kTracksCollection = '__tracks_collection__';

  String? _get(String key) => _plugin.getString(key);
  void _set(String key, String value) => _plugin.setString(key, value);

  TrackCollectionState getTrackCollection() =>
      _tracks_collections_controller.value;
  Future<void> setTrackCollection(TrackCollectionState value) async {
    final _data = [];
    for (TrackState state in value.data) {
      final value = _trackStateToString(state);
      _data.add(value);
    }
    _set(kTracksCollection, json.encode({'name': value.name, 'data': _data}));
  }

  void _init() {
    final global = _get(kTracksCollection);
    print('global: $global');
    if (global != null) {
      final globalTracks = json.decode(global) as Map<String, dynamic>;
      final List<TrackState> data = [];
      for (String ob in globalTracks['data'] as List) {
        TrackState state = _stringToTrackState(ob);
        data.add(state);
      }
      // WARNING: FOR TESTING I WILL USE TESTING DATA INSTEAD OF LOCALSTORAGE DATA
      final tracks =
          TrackCollectionState(globalTracks['name'] as String, data: data);
      _tracks_collections_controller.add(tracks);
    } else {
      _plugin.setString(
          kTracksCollection, json.encode({'name': 'global', 'data': []}));
      _init();
    }
  }

  // @override
  // Future<void> clear() {
  //   _plugin.clear();
  // }

  // @override
  // Future<void> close() {
  //   // TODO: implement close
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> delete(String key) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }

  // @override
  // read(String key) {
  //   // TODO: implement read
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> write(String key, value) {
  //   // TODO: implement write
  //   throw UnimplementedError();
  // }
}

String _trackStateToString(TrackState state) {
  final category = state.category.name;
  final type = state.type.name;
  final ob = {
    'title': state.title,
    'value': state.value,
    'description': state.description,
    'category': category,
    'type': type
  };
  return json.encode(ob);
}

TrackState _stringToTrackState(String value) {
  final stateString = json.decode(value) as Map<String, dynamic>;
  late TrackType type;
  late TrackCategory category;
  switch (stateString['type']) {
    case 'income':
      {
        type = TrackType.income;
        break;
      }
    default:
      {
        type = TrackType.expense;
      }
  }
  switch (stateString['category']) {
    case 'personal':
      {
        category = TrackCategory.personal;
        break;
      }
    case 'home':
      {
        category = TrackCategory.home;
        break;
      }
    default:
      {
        category = TrackCategory.work;
      }
  }
  final TrackState state = TrackState(
      title: stateString['title'] as String,
      value: stateString['value'] as int,
      description: stateString['description'] as String,
      type: type,
      category: category);
  return state;
}
