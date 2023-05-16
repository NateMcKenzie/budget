import 'dart:io';

import 'package:budget/transaction.dart';
import 'package:budget/account.dart';
import 'package:sqflite/sqflite.dart' as sql;

class CLI {
  Map accounts = <String, Account>{};

  void run() {
    String input = "";
    printMenu();
    while (input != "q") {
      prompt("budget");
      input = stdin.readLineSync()!;
      if (input == "q") break;
      runCommand(input);
    }
  }

  void printMenu() {
    print('''
==========Main Menu==========
  `create <name> <starting balance>` creates an account
  `transact <account name> <transaction name> <value>` sends a transaction to the named account
  `print <account name>` prints an account
  `list` lists all accounts
  'db' creates a database
  `help` presents this menu
''');
  }

  void runCommand(String command) {
    List split = command.split(" ");
    switch (split[0]) {
      case "create":
        accounts[split[1]] = Account(double.parse(split[2]), split[1]);
        break;
      case "transact":
        accounts[split[1]]
            .addTransaction(Transaction(double.parse(split[3]), split[2]));
        break;
      case "print":
        print(accounts[split[1]]);
        break;
      case "list":
        accounts.forEach((key, value) {
          print("$key: \$${value.balance} ");
        });
        break;
      case "db":
        createDB();
        break;
      case "help":
      default:
        printMenu();
        break;
    }
  }

  static void prompt(String prompt) {
    stdout.write('\x1B[33m$prompt >> \x1B[0m');
  }

  void createDB() async {
    var db = await sql.openDatabase("test.bud");
    await db.execute(
        "CREATE TABLE accounts (id INTEGER PRIMARY KEY, name TEXT, balance REAL)");
    int i = 0;
    accounts.forEach((key, value) {
      Map<String, Object?> map = value.toMap();
      map[key] = i++;
      db.insert("accounts", map);
    });
  }
}
