import 'package:finance_tracker/utils/categories/storage.dart';
import 'package:equatable/equatable.dart';
import 'package:finance_tracker/utils/event_handling/done.dart';
import 'package:finance_tracker/utils/event_handling/error.dart';
import 'package:flutter/foundation.dart';
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
      late BlocEvent event = BlocError('');
      try {
        emit(_repo.copyWith(status: CategoryStatus.progress));
        var status = await _plugin.add(ev.value);
        if (status is BlocError) {
          event = status;
          throw Error();
        }
        emit(_repo.copyWith(
            data: _plugin.data.data,
            status: CategoryStatus.done,
            event: status));
      } catch (e, stack) {
        emit(_repo.copyWith(
            status: CategoryStatus.error,
            event: BlocError(event.message, err: e, stack: stack)));
      }
    });
    // Remove Category
    on<DeleteCategoryEvent>((ev, emit) async {
      late BlocEvent event = BlocError('');
      try {
        emit(_repo.copyWith(status: CategoryStatus.progress));
        var status = await _plugin.remove(ev.value);
        if (status is BlocError) {
          event = status;
          throw Error();
        }
        emit(_repo.copyWith(
            data: _plugin.data.data,
            status: CategoryStatus.done,
            event: status));
      } catch (e, stack) {
        emit(_repo.copyWith(
            status: CategoryStatus.error,
            event: BlocError(event.message, err: e, stack: stack)));
      }
    });
    // Undo Category
    on<UndoCategoriesEvent>((ev, emit) async {
      late BlocEvent event = BlocError('');
      try {
        emit(_repo.copyWith(status: CategoryStatus.progress));
        BlocEvent status = await _plugin.undo();
        CategoriesState loaded = await _plugin.loadData();
        if (status is BlocError || loaded.event is BlocError) {
          event = status is BlocError ? status : loaded.event as BlocError;
          throw Error();
        }
        emit(_repo.copyWith(data: loaded.data, status: CategoryStatus.done));
      } catch (e, s) {
        emit(_repo.copyWith(event: BlocError(event.message, err: e, stack: s)));
      }
    });
    // Load Category
    on<LoadCategoriesEvent>((ev, emit) async {
      late BlocError event = BlocError('');
      try {
        emit(_repo.copyWith(status: CategoryStatus.progress));
        print(' ___________--_---_--__--__----_-_-------____---_-_-_----');
        final newState = await _plugin.loadData();
        if (newState.event is BlocError) {
          event = newState.event as BlocError;
          throw Error();
        }
        emit(_repo.copyWith(
            data: newState.data,
            status: CategoryStatus.done,
            event: newState.event));
      } catch (e, stack) {
        print('ERRORR');
        emit(_repo.copyWith(
            status: CategoryStatus.error,
            event: BlocError('Err in loading categories data',
                err: e, stack: stack)));
      }
    });
    // Save Category
    on<SaveCategoriesEvent>((ev, emit) async {
      late BlocError event = BlocError('');
      try {
        emit(_repo.copyWith(status: CategoryStatus.progress));
        final status = await _plugin.saveData();
        if (status is BlocError) {
          event = status;
          throw Error();
        }
        emit(_repo.copyWith(status: CategoryStatus.done));
      } catch (e, stack) {
        emit(_repo.copyWith(
            status: CategoryStatus.error,
            event: BlocError('Err in saving categories data',
                err: e, stack: stack)));
      }
    });
  }
}
