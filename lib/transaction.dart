import 'account.dart';

class Transaction {
  double value;
  String name;

  Transaction(this.value, this.name);

  Map<String, Object?> toMap() {
    Map<String, Object> map = {};
    map["value"] = value;
    map["name"] = name;
    return map;
  }
}
