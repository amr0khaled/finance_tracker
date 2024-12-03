import 'package:equatable/equatable.dart';
import 'package:finance_tracker/utils/domain_layer/track_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
part 'state.dart';
part 'event.dart';

part '../track/state.dart';
part '../track/event.dart';

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
  TrackStorage _repo;
  TrackCollectionBloc(TrackStorage repo)
      : _repo = repo,
        _state = repo.getTrackCollection(),
        super(repo.getTrackCollection()) {
    // Undo Remove Data
    on<TrackCollectionUndoTrackEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _state.undo();
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: _state.getTracks()));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Push Data
    on<TrackCollectionPushDataEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        final data = _repo.getTrackCollection();
        await _repo.setTrackCollection(data);
        emit(_state.copyWith(status: TrackCreationStatus.done));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Get Data
    on<TrackCollectionGetDataEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        final data = _repo.getTrackCollection();
        if (_state.data.isEmpty) {
          _state.data.addAll(data.data);
        }
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: _state.getTracks()));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Add Track
    on<TrackCollectionAddTrackEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        _state.data.add(event.track);
        await _repo.setTrackCollection(_state);
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: _state.getTracks()));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    on<TrackCollectionAddAllTrackEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        var orgLen = _state.data.length;
        _state.data.addAll(event.tracks);
        var modLen = _state.data.length;
        if (orgLen != modLen) {
          await _repo.setTrackCollection(_state);
          emit(_state.copyWith(
              status: TrackCreationStatus.done, data: _state.getTracks()));
        } else {
          throw Error();
        }
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Remove Track
    on<TrackCollectionRemoveTrackEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _state.remove(event.id);
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: _state.getTracks()));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    // Clear
    on<TrackCollectionClearEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _state.clear();
        await _repo.setTrackCollection(_state);
        emit(_state.copyWith(
            status: TrackCreationStatus.done, data: _state.getTracks()));
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
    on<TrackCollectionEditEvent>((event, emit) async {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        await _repo.setTrackCollection(_state);
        emit(_state.copyWith(
            status: TrackCreationStatus.done, name: event.name));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    on<TrackAllNewCategory>((event, emit) {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        _state.categories.addCategory(event.category);
        if (!_state.categories.names.contains(event.category)) {
          print("error new category not imported");
          emit(_state.copyWith(status: TrackCreationStatus.failure));
        } else {
          emit(_state.copyWith(
              status: TrackCreationStatus.done, categories: _state.categories));
        }
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    on<TrackAllRemoveCategory>((event, emit) {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        _state.categories.removeCategory(event.category);
        if (_state.categories.names.contains(event.category)) {
          print("error remove category");
          emit(_state.copyWith(status: TrackCreationStatus.failure));
        } else {
          emit(_state.copyWith(
              status: TrackCreationStatus.done, categories: _state.categories));
        }
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
    on<TrackAllUndoCategory>((event, emit) {
      emit(_state.copyWith(status: TrackCreationStatus.inProgress));
      try {
        _state.categories.undo();
        emit(_state.copyWith(
            status: TrackCreationStatus.done, categories: _state.categories));
      } catch (e) {
        emit(_state.copyWith(status: TrackCreationStatus.failure));
      }
    });
  }
}
