import 'package:finance_tracker/utils/tracks/bloc.dart';

typedef TrackName = String;
typedef TrackValue = int;
typedef TrackDesc = String;

abstract class TrackApi {
  TrackApi();
  // Get Tracks of collection
  TrackState getTrack(TrackId id);

  // Remove Track
  Future<void> removeTrack(TrackId id);

  // Add Track
  Future<void> addTrack(TrackState track);
}

class TrackNotFoundException implements Exception {}
