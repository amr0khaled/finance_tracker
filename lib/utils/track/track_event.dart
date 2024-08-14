part of './track_bloc.dart';

sealed class TrackEvent {}

class TrackSearchingEvent extends TrackEvent {}

class TrackFilteringEvent extends TrackEvent {}

class NewTrackEvent extends TrackEvent {}

class RemoveTrackEvent extends TrackEvent {}

class EditTrackEvent extends TrackEvent {}
