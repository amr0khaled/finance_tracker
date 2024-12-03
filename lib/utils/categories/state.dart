part of 'bloc.dart';

enum CategoryStatus { initial, progress, done, error }

class CategoryStateValue {}

class CategoriesState extends CategoryStateValue {
  late final List<CategoryData> _data;
  CategoriesState(
      {required List<CategoryData> data, this.status = CategoryStatus.initial})
      : _data = data;
  List<CategoryData> get data => _data;
  CategoryStatus? status;
  Future<bool> add(CategoryData value) async {
    int exists = _data.indexOf(value);
    if (exists == -1) {
      _data.add(value);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> remove(CategoryData value) async {
    int exists = _data.indexOf(value);
    if (exists != -1) {
      _data.remove(value);
      return true;
    } else {
      return false;
    }
  }

  CategoriesState copyWith({List<CategoryData>? data, CategoryStatus? status}) {
    return CategoriesState(data: data ?? _data, status: status ?? this.status);
  }
}
