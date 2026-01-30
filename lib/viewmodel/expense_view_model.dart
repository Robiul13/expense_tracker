import 'package:flutter/material.dart';
import '../db/expense_db.dart';
import '../model/expense_model.dart';

class ExpenseViewModel extends ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Rent',
    'Others',
  ];

  double get totalExpense => _expenses.fold(0, (sum, e) => sum + e.amount);

  double categoryTotal(String category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0, (sum, e) => sum + e.amount);
  }

  Future<void> loadExpenses() async {
    _expenses = await ExpenseDB.getExpenses();
    notifyListeners();
  }

  Future<void> addExpense(String title, double amount, String category) async {
    final expense = Expense(
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now().toString().split(' ')[0],
    );

    await ExpenseDB.insertExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await ExpenseDB.deleteExpense(id);
    await loadExpenses();
  }

  Future<void> updateExpense(
    int id,
    String title,
    String category,
    double amount,
  ) async {
    final updated = Expense(
      id: id,
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now().toString().split(' ')[0],
    );

    await ExpenseDB.updateExpense(updated);
    await loadExpenses();
  }
}
