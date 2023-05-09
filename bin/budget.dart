import 'package:budget/account.dart';
import 'package:budget/transaction.dart';

void main(List<String> arguments) {
  print('Hello world!');
  Account testAccount = Account(0, "test");
  testAccount.addTransaction(Transaction(10, "Test"));
  print(testAccount.balance);
  testAccount.addTransaction(Transaction(20, "Test2"));
  print(testAccount.balance);
}
