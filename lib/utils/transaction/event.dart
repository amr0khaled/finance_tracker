part of 'bloc.dart';

class TransactionsEvent extends Equatable {
  const TransactionsEvent();
  @override
  List get props => [];
}

class AddTransactionEvent extends TransactionsEvent {
  const AddTransactionEvent(this.transaction);
  final Transaction transaction;
  @override
  List get props => [transaction];
}

class DeleteTransactionEvent extends TransactionsEvent {
  const DeleteTransactionEvent(this.transaction);
  final Transaction transaction;
  @override
  List get props => [transaction];
}

class EditTransactionEvent extends TransactionsEvent {
  EditTransactionEvent(this.transaction,
      {this.title, this.desc, this.categories, this.date, this.amount});

  String? title;
  String? desc;
  List<CategoryData>? categories;
  String? date;
  int? amount;

  final Transaction transaction;
  @override
  List get props => [transaction, title, desc, categories, date, amount];
}

class UndoTransactionEvent extends TransactionsEvent {
  const UndoTransactionEvent();
}

class LoadTransactionEvent extends TransactionsEvent {
  const LoadTransactionEvent();
}

class SaveTransactionEvent extends TransactionsEvent {
  const SaveTransactionEvent();
}
