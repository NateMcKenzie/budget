import 'package:budget/account.dart';
import 'package:budget/transaction.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

class DatabaseWrapper {
  late sql.Database db;
  bool initialized = false;

  void saveDB(List<Account> accounts) async {
    if (!initialized) await initDatabase();

    for (Account account in accounts) {
      Map<String, Object?> accountMap = account.toMap();
      await db.insert("accounts", accountMap);
      List<Map<String, Object?>> maps = await db
          .query("accounts", where: "name = ?", whereArgs: [account.name]);
      Object id = maps[0]["id"]!;
      int accountID = int.parse(id.toString());

      // Use a batch transaction for improved performance
      await db.transaction((txn) async {
        for (Transaction transaction in account.transactions) {
          Map<String, Object?> transactionMap = transaction.toMap();
          transactionMap["account_id"] = accountID;
          await txn.insert("transactions", transactionMap);
        }
      });
    }

    final databasesPath = await sql.getDatabasesPath();
    print('Path to SQLite databases: $databasesPath');
  }

  Future<List<Account>> loadDB() async {
    if (!initialized) await initDatabase();

    List<Account> accounts = [];

    List<Map<String, Object?>> accountMaps = await db.query("accounts");
    for (Map<String, Object?> accountMap in accountMaps) {
      int accountID = accountMap["id"] as int;

      List<Map<String, Object?>> transactionMaps = await db.query(
          "transactions",
          where: "account_id = ?",
          whereArgs: [accountID]);

      List<Transaction> transactions = [];
      for (Map<String, Object?> transactionMap in transactionMaps) {
        Transaction transaction = Transaction.fromMap(transactionMap);
        transactions.add(transaction);
      }
      accounts.add(Account.fromMap(accountMap, transactions));
    }

    return accounts;
  }

  Future<void> initDatabase() async {
    ffi.databaseFactory = ffi.databaseFactoryFfi;
    db = await sql.openDatabase("test.bud");
    if (!await tableExists(db, "accounts")) {
      await db.execute(
          "CREATE TABLE accounts (id INTEGER PRIMARY KEY, name TEXT, balance REAL)");
    }
    if (!await tableExists(db, "transactions")) {
      await db.execute(
          "CREATE TABLE transactions (id INTEGER PRIMARY KEY, account_id INTEGER, name TEXT, value REAL)");
    }
    initialized = true;
  }

  Future<bool> tableExists(sql.Database db, String name) async {
    final List<Map<String, Object?>> queryResult = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', name],
    );
    return queryResult.isNotEmpty;
  }
}
