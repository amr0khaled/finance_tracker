part of '../tracks/tracks_bloc.dart';

typedef TrackId = String;
typedef TrackValue = int;

enum TrackCategory { personal, work, home }

enum TrackType { income, expense }

// ignore: must_be_immutable
class TrackState extends Equatable {
  TrackId _id = '';
  String title;
  final TrackType type;
  TrackValue value;
  final TrackCategory category;
  String description;
  final TrackCreationStatus status;

  TrackState(
      {this.title = '',
      this.type = TrackType.income,
      this.value = 0,
      this.category = TrackCategory.personal,
      this.description = '',
      this.status = TrackCreationStatus.initial,
      TrackId? id}) {
    // TODO: change Id to UUID V4
    _id = id ?? const Uuid().v8();
  }
  TrackId get id => _id;
  TrackState copyWith(
      {String? title,
      TrackType? type,
      TrackValue? value,
      TrackCategory? category,
      String? description,
      TrackCreationStatus? status}) {
    return TrackState(
        title: title ?? this.title,
        type: type ?? this.type,
        value: value ?? this.value,
        category: category ?? this.category,
        description: description ?? this.description,
        status: status ?? this.status);
  }

  Future<void> edit(
      {String? title, TrackValue? value, String? description}) async {
    try {
      title = title ?? this.title;
      value = value ?? this.value;
      description = description ?? this.description;
    } catch (e, stack) {
      ErrorHint('${e.toString()} ${stack.toString()}');
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

  @override
  // TODO: implement props
  List<Object?> get props => [title, type, value, category, description];
}
