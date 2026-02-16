import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../db/hybrid_expense_repository.dart';
import '../model/expense_model.dart';

class ExpenseViewModel extends ChangeNotifier {

  final HybridExpenseRepository _repo = HybridExpenseRepository();

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

  // ✅ Load
  Future<void> loadExpenses() async {
    _expenses = await _repo.fetchExpenses();
    notifyListeners();
  }

  // ✅ Add
  Future<void> addExpense(
      String title,
      double amount,
      String category,
      ) async {

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final expense = Expense(
      userId: user.id,
      title: title,
      amount: amount,
      category: category,
    );

    await _repo.addExpense(expense); // 🔥 IMPORTANT
    await loadExpenses();
  }

  // ✅ Delete
  Future<void> deleteExpense(String id) async {
    await _repo.deleteExpense(id);
    await loadExpenses();
  }

  // ✅ Update
  Future<void> updateExpense(
      Expense oldExpense,
      String title,
      String category,
      double amount,
      ) async {

    final updated = oldExpense.copyWith(
      title: title,
      category: category,
      amount: amount,
      isSynced: false,
    );

    await _repo.updateExpense(updated);
    await loadExpenses();
  }

  // 🔹 TOTAL
  double get totalExpense =>
      _expenses.fold(0, (sum, e) => sum + e.amount);

  double categoryTotal(String category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0, (sum, e) => sum + e.amount);
  }

  List<Expense> get filteredExpenses {
    return _expenses.where((e) {
      return e.createdAt.month == _selectedMonth.month &&
          e.createdAt.year == _selectedMonth.year;
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
