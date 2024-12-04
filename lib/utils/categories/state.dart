part of 'bloc.dart';

enum CategoryStatus { initial, progress, done, error }

class CategoryStateValue {}

class CategoriesState extends CategoryStateValue {
  late final List<CategoryData> _data;
  late BlocEvent? event;
  CategoriesState(
      {required List<CategoryData> data,
      this.status = CategoryStatus.initial,
      this.event})
      : _data = data;
  List<CategoryData> get data => _data;
  CategoryStatus? status;
  Future<BlocEvent> add(CategoryData value) async {
    int exists = _data.indexOf(value);
    if (exists == -1) {
      _data.add(value);
      return BlocDone('$value is added');
    } else {
      return BlocError('$value is already exists');
    }
  }

  Future<BlocEvent> remove(CategoryData value) async {
    int exists = _data.indexOf(value);
    if (exists != -1) {
      _data.remove(value);
      return BlocDone('$value is removed');
    } else {
      return BlocError('$value is not found');
    }
  }

  Future<BlocEvent> insert(int i, CategoryData value) async {
    if (value.isNotEmpty) {
      _data.insert(i, value);
      return BlocDone('SUCCESS: $value inserted at $i');
    } else {
      return BlocError('FAILURE: Inserting $value at $i');
    }
  }

  CategoriesState copyWith(
      {List<CategoryData>? data, CategoryStatus? status, BlocEvent? event}) {
    return CategoriesState(
        data: data ?? _data, status: status ?? this.status, event: event);
  }
}
