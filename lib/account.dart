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

  @override
  String toString() {
    String output = "Account: $name\n";
    output += "Balance: \$$_balance\n";
    output += "Transactions:\n";
    for (Transaction transaction in _transactions) {
      output += "\t${transaction.name}: \$${transaction.value}\n";
    }
    return output;
  }

  get balance => _balance;
}
