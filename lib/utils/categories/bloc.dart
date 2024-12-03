import 'package:finance_tracker/utils/categories/storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';
part 'event.dart';

class CategoryBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesState _repo;
  CategoryStorage _plugin;
  CategoryBloc(CategoryStorage plugin)
      : _plugin = plugin,
        _repo = plugin.data,
        super(plugin.data) {
    // Add New Category
    on<AddCategoryEvent>((ev, emit) async {
      try {
        emit(_repo.copyWith(status: CategoryStatus.initial));
        var status = await _repo.add(ev.value);
        if (!status) {
          Error();
        }
        emit(_repo.copyWith(data: _repo.data, status: CategoryStatus.done));
      } catch (e, stack) {
        print("Err in Add Category: $e");
        print("Stack: $stack");
        emit(_repo.copyWith(status: CategoryStatus.error));
      }
    });
    // Remove Category
    on<DeleteCategoryEvent>((ev, emit) async {
      try {
        emit(_repo.copyWith(status: CategoryStatus.initial));
        var status = await _repo.remove(ev.value);
        if (!status) {
          Error();
        }
        emit(_repo.copyWith(data: _repo.data, status: CategoryStatus.done));
      } catch (e, stack) {
        print("Err in Delete Category : $e");
        print("Stack: $stack");
        emit(_repo.copyWith(status: CategoryStatus.error));
      }
    });
    // Load Category
    on<LoadCategoriesEvent>((ev, emit) async {
      try {
        emit(_repo.copyWith(status: CategoryStatus.initial));
        await _plugin.loadData();
        emit(_repo.copyWith(data: _repo.data, status: CategoryStatus.done));
      } catch (e, stack) {
        print("Err in Load Category: $e");
        print("Stack: $stack");
        emit(_repo.copyWith(status: CategoryStatus.error));
      }
    });
    // Save Category
    on<SaveCategoriesEvent>((ev, emit) async {
      try {
        emit(_repo.copyWith(status: CategoryStatus.initial));
        await _plugin.saveData();
        emit(_repo.copyWith(data: _repo.data, status: CategoryStatus.done));
      } catch (e, stack) {
        print("Err in Save Category: $e");
        print("Stack: $stack");
        emit(_repo.copyWith(status: CategoryStatus.error));
      }
    });
  }
}
