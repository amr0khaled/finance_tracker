import 'package:finance_tracker/utils/track.dart';

typedef TrackName = String;
typedef TrackValue = int;
typedef TrackDesc = String;

abstract class TrackApi {
  TrackApi();

  // Get Tracks of collection
  TrackData getTrack(TrackId id);

  // Remove Track
  Future<void> removeTrack(TrackId id);

  // Add Track
  Future<void> addTrack(TrackData track);

  // Edit Track
  Future<void> editTrack(TrackId id, TrackEditData edit);
}

class TrackNotFoundException implements Exception {}
