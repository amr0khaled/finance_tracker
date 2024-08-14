part of './track_bloc.dart';

enum TrackFilterState {
  init,
  filtering,
  completed
}

enum TrackSearchState {
  init,
  searching,
  completed
}

enum TrackState {
  init,
  addNew,
  edit,
  remove,
}

enum TrackNew {
  init,
  adding,
  done
}

enum TrackEdit {
  init,
  editing,
  done
}

enum TrackRemove {
  init,
  removing,
  done
}



enum TrackFilter

sealed class TrackState extends Equatable {
  const TrackState()
}
