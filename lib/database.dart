import 'package:budget/account.dart';
import 'package:budget/transaction.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

void saveDB(List<Account> accounts) async {
  sql.Database db = await initDatabase();

  for (Account account in accounts) {
    Map<String, Object?> accountMap = account.toMap();
    await db.insert("accounts", accountMap);
    List<Map<String, Object?>> maps =
        await db.query("accounts", where: "name=${account.name}");
    Object id = maps[0]["id"]!;
    int accountID = int.parse(id.toString());
    for (Transaction transaction in account.transactions) {
      Map<String, Object?> transactionMap = transaction.toMap();
      transactionMap["account_id"] = accountID;
      await db.insert("transactions", transactionMap);
    }
  }

  final databasesPath = await sql.getDatabasesPath();
  print('Path to SQLite databases: $databasesPath');
}

Future<sql.Database> initDatabase() async {
  ffi.databaseFactory = ffi.databaseFactoryFfi;
  var db = await sql.openDatabase("test.bud");
  if (!await tableExists(db, "accounts")) {
    await db.execute(
        "CREATE TABLE accounts (id INTEGER PRIMARY KEY, name TEXT, balance REAL)");
  }
  if (!await tableExists(db, "transactions")) {
    await db.execute(
        "CREATE TABLE transactions (id INTEGER PRIMARY KEY, account_id INTEGER, name TEXT, value REAL)");
  }
  return db;
}

Future<bool> tableExists(sql.Database db, String name) async {
  final List<Map<String, Object?>> queryResult = await db.query(
    'sqlite_master',
    where: 'type = ? AND name = ?',
    whereArgs: ['table', name],
  );
  return queryResult.isNotEmpty;
}
