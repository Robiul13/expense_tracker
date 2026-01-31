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

  DateTime _selectedMonth =
  DateTime(DateTime.now().year, DateTime.now().month);

  DateTime get selectedMonth => _selectedMonth;

  void changeMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

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

  List<Expense> get filteredExpenses {
    return _expenses.where((e) {
      final d = DateTime.parse(e.date);
      return d.month == _selectedMonth.month &&
          d.year == _selectedMonth.year;
    }).toList();
  }

  double get filteredTotalExpense {
    return filteredExpenses.fold(0, (sum, e) => sum + e.amount);
  }

  double filteredCategoryTotal(String category) {
    return filteredExpenses
        .where((e) => e.category == category)
        .fold(0, (sum, e) => sum + e.amount);
  }

}
