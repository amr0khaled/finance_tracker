import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'tracks_state.dart';
part 'tracks_event.dart';

part '../track/track_state.dart';
part '../track/track_event.dart';

class TrackCubit extends Cubit<TrackState> {
  TrackCubit() : super(TrackState());
  Future<void> edit(
          {String? title, TrackValue? value, String? description}) async =>
      emit(state.edit(title: title, value: value, description: description)
          as TrackState);
}

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  TrackBloc() : super(TrackState()) {
    on<TrackEditEvent>((event, emit) async {
      emit(state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        List<Object?> props = event.props;
        await state.edit(
            title: props[0] as String,
            value: props[1] as TrackValue,
            description: props[2] as String);
        emit(state.copyWith(status: TrackCreationStatus.done));
      } catch (e) {
        emit(state.copyWith(status: TrackCreationStatus.failure));
      }
    });
  }
  Future<void> edit(
      {String? title, TrackValue? value, String? description}) async {}
}

class TrackCollectionBloc extends Bloc<TrackEvent, TrackCollectionState> {
  TrackCollectionState _state;
  TrackCollectionBloc(TrackCollectionState state)
      : _state = state,
        super(TrackCollectionState('global', data: const [])) {
    // Add Track
    on<TrackCollectionAddTrackEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _state.addTrack(event.track);
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: _state.getTracks()));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    on<TrackCollectionAddAllTrackEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _state.addAllTracks(event.tracks);
        emit(_state.copyWith(status: TrackCreationStatus.done));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Remove Track
    on<TrackCollectionRemoveTrackEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _state.remove(event.id);
        emit(_state.copyWith(status: TrackCreationStatus.done));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Clear
    on<TrackCollectionClearEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _state.clear();
        emit(_state.copyWith(status: TrackCreationStatus.done));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Filter
    on<TrackCollectionFilteringEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        TrackCollection filteredTracks = await _state.filter(event.search);
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: filteredTracks));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Filter Category
    on<TrackCollectionFilteringCategoryEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        TrackCollection filteredTracks =
            await _state.filterCategory(event.categories);
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: filteredTracks));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    on<TrackCollectionEditEvent>((event, emit) {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        emit(_state.copyWith(
            status: TrackCreationStatus.done, name: event.name));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
  }
}
