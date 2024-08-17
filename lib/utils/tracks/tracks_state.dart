part of 'tracks_bloc.dart';

enum TrackCreationStatus { initial, inProgress, done, failure }

typedef TrackCollectionId = String;
typedef TrackCollection = List<TrackState>;

class TrackCollectionState extends Equatable {
  static TrackCollectionId _id = '';
  final String name;
  final TrackCreationStatus status;
  final TrackCollection data;
  TrackCollectionState(this.name,
      {this.status = TrackCreationStatus.initial,
      required this.data,
      TrackCollectionId? id}) {
    _id = id ?? const Uuid().v4();
  }
  late TrackState lastRemovedTrack;
  late int lastRemovedTrackIndex;
  TrackCollectionState copyWith(
          {String? name, TrackCreationStatus? status, TrackCollection? data}) =>
      TrackCollectionState(name ?? this.name,
          status: status ?? this.status, data: data ?? this.data);

  // get Collection Id
  TrackCollectionId get collectionId => _id;

  // get All Tracks in collection
  TrackCollection getTracks() => data;

  // Filter Tracks and return it
  Future<TrackCollection> filterCategory(List<TrackCategory> categories) async {
    try {
      TrackCollection result = [];
      for (TrackState track in data) {
        if (categories.contains(track.category)) {
          result.add(track);
        }
      }
      return result;
    } catch (e, stack) {
      print(ErrorHint(
          'filterCategory($categories): ${e.toString()} ${stack.toString()}'));
      return data;
    }
  }

  Future<TrackCollection> filter(String search) async {
    try {
      TrackCollection result = [];
      bool hasIncomeKeyword = search.toLowerCase().contains('income');
      bool hasExpenseKeyword = search.toLowerCase().contains('expense');
      bool hasPersonalKeyword = search.toLowerCase().contains('personal');
      bool hasHomeKeyword = search.toLowerCase().contains('home');
      bool hasWorkKeyword = search.toLowerCase().contains('work');
      if (search.isEmpty) {
        return data;
      }
      if (hasIncomeKeyword) {
        result.addAll(data.where((e) => e.type == TrackType.income));
      }
      if (hasExpenseKeyword) {
        result.addAll(data.where((e) => e.type == TrackType.expense));
      }
      if (hasPersonalKeyword) {
        result.addAll(data.where((e) => e.category == TrackCategory.personal));
      }
      if (hasHomeKeyword) {
        result.addAll(data.where((e) => e.category == TrackCategory.home));
      }
      if (hasWorkKeyword) {
        result.addAll(data.where((e) => e.category == TrackCategory.work));
      }
      result.addAll(data.where((e) =>
          e.title.toLowerCase().split(' ').contains(search.toLowerCase()) ||
          e.value.toString().split(' ').contains(search.toLowerCase()) ||
          e.description
              .toLowerCase()
              .split(' ')
              .contains(search.toLowerCase())));
      return result;
    } catch (e, stack) {
      print(ErrorHint('filter($search): ${e.toString()} ${stack.toString()}'));
      return data;
    }
  }

  // Add Track
  Future<void> addTrack(TrackState track) async {
    try {
      data.add(track);
    } catch (e, stack) {
      print(ErrorHint('addTrack($track): ${e.toString()} ${stack.toString()}'));
    }
  }

  // Remove Track
  Future<void> remove(TrackId id) async {
    try {
      lastRemovedTrackIndex = data.indexWhere((e) => e.id == id);
      print('last :$lastRemovedTrackIndex');
      lastRemovedTrack = data[lastRemovedTrackIndex];
      data.removeWhere((e) => e.id == id);
    } catch (e, stack) {
      print(ErrorHint('remove($id): ${e.toString()} ${stack.toString()}'));
    }
  }

  // Undo Remove Track
  Future<void> undo() async {
    try {
      data.insert(lastRemovedTrackIndex, lastRemovedTrack);
    } catch (e, stack) {
      print(ErrorHint('undo(): ${e.toString()} ${stack.toString()}'));
    }
  }

  // Clear Track
  Future<void> clear() async {
    try {
      data.clear();
    } catch (e, stack) {
      print(ErrorHint('clear(): ${e.toString()} ${stack.toString()}'));
    }
  }

  @override
  List<Object?> get props => [name, data, status];
}