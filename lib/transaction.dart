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

  static Transaction fromMap(Map<String, Object?> map) {
    double value = double.tryParse(map["value"].toString()) ?? 0;
    String name = map["name"].toString();
    return Transaction(value, name);
  }
}
