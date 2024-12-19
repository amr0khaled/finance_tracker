// ignore_for_file: prefer_final_fields

import 'package:equatable/equatable.dart';
import 'package:finance_tracker/utils/categories/storage.dart';
import 'package:finance_tracker/utils/event_handling/done.dart';
import 'package:finance_tracker/utils/event_handling/error.dart';
import 'package:finance_tracker/utils/transaction/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

part 'state.dart';
part 'event.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, Transactions> {
  TransactionsStorage _plugin;
  Transactions _repo;
  TransactionsBloc(TransactionsStorage plugin)
      : _plugin = plugin,
        _repo = plugin.data,
        super(plugin.data) {
    // Add Transactions
    on<AddTransactionEvent>((ev, emit) async {
      late BlocEvent event = const BlocEvent('');
      try {
        emit(_repo.copyWith(status: TransactionsStatus.progress));
        event = await _plugin.add(ev.transaction);
        if (event is BlocError) {
          throw Error();
        }
        emit(_repo.copyWith(
            data: _plugin.data.data,
            event: event,
            status: TransactionsStatus.done));
      } catch (e) {
        emit(_repo.copyWith(event: event, status: TransactionsStatus.error));
      }
    });
    // Remove Transactions
    on<DeleteTransactionEvent>((ev, emit) async {
      late BlocEvent event = const BlocEvent('');
      try {
        emit(_repo.copyWith(status: TransactionsStatus.progress));
        event = await _plugin.remove(ev.transaction);
        if (event is BlocError) {
          throw Error();
        }
        emit(_repo.copyWith(
            data: _plugin.data.data,
            event: event,
            status: TransactionsStatus.done));
      } catch (e) {
        emit(_repo.copyWith(event: event, status: TransactionsStatus.error));
      }
    });
    // Edit Transactions
    on<EditTransactionEvent>((ev, emit) async {
      late BlocEvent event = const BlocEvent('');
      try {
        emit(_repo.copyWith(status: TransactionsStatus.progress));
        event = await _plugin.edit(ev.transaction,
            title: ev.title,
            desc: ev.desc,
            categories: ev.categories,
            date: ev.date,
            amount: ev.amount,
            contact: ev.contact);
        if (event is BlocError) {
          throw Error();
        }
        emit(_repo.copyWith(
            data: _plugin.data.data,
            event: event,
            status: TransactionsStatus.done));
      } catch (e) {
        emit(_repo.copyWith(event: event, status: TransactionsStatus.error));
      }
    });
    // Load Transactions
    on<LoadTransactionEvent>((ev, emit) async {
      late BlocEvent event = const BlocEvent('');
      try {
        emit(_repo.copyWith(status: TransactionsStatus.progress));
        var newData = await _plugin.loadData();
        if (newData.event is BlocError) {
          event = newData.event as BlocError;
          throw Error();
        }
        emit(_repo.copyWith(
            data: _plugin.data.data,
            event: newData.event,
            status: TransactionsStatus.done));
      } catch (e) {
        emit(_repo.copyWith(event: event, status: TransactionsStatus.error));
      }
    });
    // Save Transactions
    on<SaveTransactionEvent>((ev, emit) async {
      late BlocEvent event = const BlocEvent('');
      try {
        emit(_repo.copyWith(status: TransactionsStatus.progress));
        event = await _plugin.saveData();
        if (event is BlocError) {
          throw Error();
        }
        emit(_repo.copyWith(event: event, status: TransactionsStatus.done));
      } catch (e) {
        emit(_repo.copyWith(event: event, status: TransactionsStatus.error));
      }
    });
  }
}
