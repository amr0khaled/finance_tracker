import 'package:finance_tracker/utils/data_layer/track_api.dart';
import 'package:flutter/material.dart';

typedef TrackId = String;
typedef TrackValue = int;

enum TrackCategory { personal, work, home }

enum TrackType { income, expense }

class TrackEditData {
  final String? name;
  final TrackType? type;
  final int? value;
  final TrackCategory? category;
  final String? description;
  const TrackEditData(
      {this.name, this.type, this.value, this.category, this.description});
}

class TrackData {
  TrackId _id = '';
  TrackData(
      {required this.name,
      required this.type,
      required this.value,
      required this.category,
      this.description = ''}) {
    // TODO: change Id to UUID V4
    _id = name + name;
  }
  String name;
  TrackType type;
  TrackValue value;
  TrackCategory category;
  String description;
  TrackId get id => _id;
  Future<TrackCreationStatus> edit(TrackEditData changes) async {
    try {
      name = changes.name!;
      type = changes.type!;
      value = changes.value!;
      category = changes.category!;
      description = changes.description!;
      return TrackCreationStatus.done;
    } catch (e, stack) {
      ErrorHint('${e.toString()} ${stack.toString()}');
      return TrackCreationStatus.failure;
    }
  }

  int categoryNumber() {
    switch (category) {
      case TrackCategory.personal:
        {
          return 1;
        }
      case TrackCategory.work:
        {
          return 2;
        }
      case TrackCategory.home:
        {
          return 3;
        }
    }
  }

  bool isExpense() {
    switch (type) {
      case TrackType.expense:
        {
          return true;
        }
      case TrackType.income:
        {
          return false;
        }
    }
  }
}

enum TrackCreationStatus { initial, inProgress, done, failure }

typedef TrackCollectionId = String;

class TrackCollection extends TrackApi {
  TrackCollectionId _id = '';
  final String name;
  final List<TrackData> _data = [];
  TrackCollection(this.name) {
    // TODO: change Id to UUID V4
    _id = name + name;
  }
  TrackCollectionId get id => _id;

  @override
  TrackData getTrack(TrackId id) => _data.lastWhere((e) => e._id == id);

  Future<List<TrackData>> getAllTracks() async => _data;

  @override
  Future<TrackCreationStatus> addTrack(TrackData track) async {
    try {
      _data.add(track);
      return TrackCreationStatus.done;
    } catch (e, stack) {
      ErrorHint('${e.toString()} ${stack.toString()}');
      return TrackCreationStatus.failure;
    }
  }

  @override
  Future<TrackCreationStatus> editTrack(TrackId id, TrackEditData edit) async {
    try {
      TrackData track = _data.lastWhere((e) => e._id == id);
      track.edit(edit);
      return TrackCreationStatus.done;
    } catch (e, stack) {
      ErrorHint('${e.toString()} ${stack.toString()}');
      return TrackCreationStatus.failure;
    }
  }

  @override
  Future<TrackCreationStatus> removeTrack(TrackId id) async {
    try {
      _data.removeWhere((e) => e._id == id);
      return TrackCreationStatus.done;
    } catch (e, stack) {
      ErrorHint('${e.toString()} ${stack.toString()}');
      return TrackCreationStatus.failure;
    }
  }

  Future<TrackCreationStatus> clearTracks() async {
    try {
      _data.clear();
      return TrackCreationStatus.done;
    } catch (e, stack) {
      ErrorHint('${e.toString()} ${stack.toString()}');
      return TrackCreationStatus.failure;
    }
  }
}
