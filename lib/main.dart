import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/expense_home_page.dart';
import 'viewmodel/expense_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ExpenseHomePage(),
    );
  }
}
