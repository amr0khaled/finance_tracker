part of 'tracks_bloc.dart';

// WARNING: There are no events for Track
// so we will implement function for the events of the Collection inside Track class

class TrackEvent extends Equatable {
  const TrackEvent();
  @override
  List<Object?> get props => [];
}

class TrackEditEvent extends TrackEvent {
  final TrackState track;
  const TrackEditEvent(this.track,
      {String? title, TrackValue? value, String? description});
  @override
  List<Object?> get props => [track];
}

// Collection Events

class TrackCollectionUndoTrackEvent extends TrackEvent {
  const TrackCollectionUndoTrackEvent();
  @override
  List<Object?> get props => [];
}

class TrackCollectionPushDataEvent extends TrackEvent {
  const TrackCollectionPushDataEvent();
  @override
  List<Object?> get props => [];
}

class TrackCollectionGetDataEvent extends TrackEvent {
  const TrackCollectionGetDataEvent();
  @override
  List<Object?> get props => [];
}

class TrackCollectionFilteringEvent extends TrackEvent {
  final String search;
  const TrackCollectionFilteringEvent(this.search);
  @override
  List<Object?> get props => [search];
}

class TrackCollectionFilteringCategoryEvent extends TrackEvent {
  final List<TrackCategory> categories;
  const TrackCollectionFilteringCategoryEvent(this.categories);
  @override
  List<Object?> get props => [categories];
}

class TrackCollectionAddTrackEvent extends TrackEvent {
  final TrackState track;
  const TrackCollectionAddTrackEvent(this.track);
  @override
  List<Object?> get props => [track];
}

class TrackCollectionAddAllTrackEvent extends TrackEvent {
  final List<TrackState> tracks;
  const TrackCollectionAddAllTrackEvent(this.tracks);
  @override
  List<Object?> get props => [tracks];
}

class TrackCollectionRemoveTrackEvent extends TrackEvent {
  final TrackId id;
  const TrackCollectionRemoveTrackEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class TrackCollectionClearEvent extends TrackEvent {}

class TrackCollectionEditEvent extends TrackEvent {
  final String name;
  const TrackCollectionEditEvent(this.name);
  @override
  List<Object?> get props => [name];
}

// Whole Data Events

class TrackAllEvent {}

class TrackAllGetEvent extends TrackEvent {}

class TrackAllAddCollectionEvent extends TrackEvent {}

class TrackAllRemoveCollectionEvent extends TrackEvent {}

class TrackAllClearCollectionEvent extends TrackEvent {}
