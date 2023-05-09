import 'package:budget/Account.dart';
import 'package:budget/transaction.dart';
import 'package:test/test.dart';

void main() {
  test('Account Balance', () {
    Account testAccount = Account(0, "test");
    testAccount.addTransaction(Transaction(10, "Test"));
    expect(testAccount.balance, 10.0);
    testAccount.addTransaction(Transaction(20, "Test2"));
    expect(testAccount.balance, 30.0);
  });
}
