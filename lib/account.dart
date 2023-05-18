import 'transaction.dart';

class Account {
  double _balance;
  String name;
  final List<Transaction> _transactions = List.empty(growable: true);

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

  Map<String, Object?> toMap() {
    Map<String, Object> map = {};
    map["name"] = name;
    map["balance"] = _balance;
    //map["transactions"] = _transactions;
    return map;
  }

  get balance => _balance;
  get transactions => _transactions;
}
