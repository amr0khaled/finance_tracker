part of 'bloc.dart';

enum CategoryStatus { initial, progress, done, error }

class CategoryState {
  CategoryState({this.value = '', this.status = CategoryStatus.initial});
  String? value;
  CategoryStatus? status;
  Future<void> edit(String value) async {
    try {
      this.value = value;
    } catch (e, stack) {
      ErrorHint('${e.toString()} ${stack.toString()}');
    }
  }

  CategoryState copyWith({String? value, CategoryStatus? status}) {
    return CategoryState(
        value: value ?? this.value, status: status ?? this.status);
  }
}
