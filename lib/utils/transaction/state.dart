part of 'bloc.dart';

enum TransactionsStatus { initial, progress, done, error }

class Transaction {
  Transaction(
      {required this.title,
      this.desc,
      required this.categories,
      required this.date,
      required this.amount,
      this.contact});
  final String title;
  final String? desc;
  final List<CategoryData> categories;
  final String date;
  final int amount;
  Contact? contact;
  Transaction copyWith(
      {String? title,
      String? desc,
      List<CategoryData>? categories,
      String? date,
      int? amount,
      Contact? contact}) {
    return Transaction(
        title: title ?? this.title,
        desc: desc ?? this.desc,
        categories: categories ?? this.categories,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        contact: contact ?? this.contact);
  }
}

class Transactions {
  final List<Transaction> _data;
  final BlocEvent? event;
  Transactions(
      {required List<Transaction> data,
      this.status = TransactionsStatus.initial,
      this.event})
      : _data = data;
  List<Transaction> get data => _data;

  Future<BlocEvent> add(Transaction transaction) async {
    var status = _data.indexOf(transaction);
    if (status == -1) {
      _data.add(transaction);
      return BlocDone('Transaction ${transaction.title} has been added');
    } else {
      return BlocError('Transaction ${transaction.title} exists already');
    }
  }

  Future<int> indexOf(Transaction transaction) async =>
      _data.indexOf(transaction);

  Future<BlocEvent> insert(int i, Transaction transaction) async {
    try {
      _data.insert(i, transaction);
      return BlocDone('SUCCESS: $transaction inserted at $i');
    } catch (e, s) {
      return BlocError('FAILURE: Inserting $transaction at $i',
          err: e, stack: s);
    }
  }

  Future<BlocEvent> remove(Transaction transaction) async {
    var status = _data.indexOf(transaction);
    if (status != -1) {
      _data.remove(transaction);
      return BlocDone('Transaction ${transaction.title} has been removed');
    } else {
      return BlocError('Transaction ${transaction.title} not found');
    }
  }

  Future<BlocEvent> edit(Transaction transaction,
      {String? title,
      String? desc,
      List<CategoryData>? categories,
      String? date,
      int? amount,
      Contact? contact}) async {
    var status = _data.indexOf(transaction);
    if (status != -1) {
      var transaction = _data.removeAt(status);
      var newTransaction = transaction.copyWith(
          title: title,
          desc: desc,
          date: date,
          categories: categories,
          amount: amount,
          contact: contact);
      _data.insert(status, newTransaction);
      return BlocDone('Transaction ${transaction.title} has been edited');
    } else {
      return BlocError('Transaction ${transaction.title} not found');
    }
  }

  final TransactionsStatus status;
  Transactions copyWith(
      {List<Transaction>? data, TransactionsStatus? status, BlocEvent? event}) {
    return Transactions(
        data: data ?? this.data,
        status: status ?? this.status,
        event: event ?? this.event);
  }
}
