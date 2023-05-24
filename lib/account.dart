import 'transaction.dart';

class Account {
  final int _id;
  double _balance;
  String name;
  final List<Transaction> _transactions;

  Account(this._balance, this.name,
      {List<Transaction>? transactions, int id = 0})
      : _id = id,
        _transactions = transactions ?? [];

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _balance += transaction.value;
  }

  @override
  String toString() {
    String output = "Account: ($_id) $name\n";
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
    return map;
  }

  static Account fromMap(
      Map<String, Object?> map, List<Transaction> transactions) {
    int id = int.tryParse(map["id"].toString()) ?? 0;
    double balance = double.tryParse(map["balance"].toString()) ?? 0;
    String name = map["name"].toString();
    return Account(balance, name, transactions: transactions, id: id);
  }

  get balance => _balance;
  get transactions => _transactions;
}
