import 'transaction.dart';

class Account {
  double _balance;
  String name;
  List<Transaction> _transactions = List.empty(growable: true);

  Account(this._balance, this.name);

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _balance += transaction.value;
  }

  get balance => _balance;
}
