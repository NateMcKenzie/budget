import 'dart:math';

import 'package:flutter/material.dart';
import 'package:budget/account.dart';
import 'package:budget/transaction.dart';
import 'package:budget/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Budget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Account> accounts = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    List<Text> accountWidgets = List.generate(
        accounts.length, (index) => Text(accounts[index].toString()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Row(children: [
          TextButton(
            child: const Text("Save"),
            onPressed: () => saveDB(accounts),
          ),
          Column(children: accountWidgets)
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => accounts.add(generateAccount())),
      ),
    );
  }

  Account generateAccount() {
    Account dummyAccount =
        Account(Random().nextDouble() * 500, accounts.length.toString());
    for (int i = 0; i < Random().nextInt(6); i++) {
      dummyAccount.addTransaction(generateTransaction());
    }
    return dummyAccount;
  }

  Transaction generateTransaction() {
    return Transaction(Random().nextDouble() * 500, "Dummy Transaction");
  }
}
