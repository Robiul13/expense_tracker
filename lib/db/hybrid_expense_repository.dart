import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/expense_model.dart';
import 'expense_db.dart';

class HybridExpenseRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // 🔹 Internet check
  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
  }

  // 🔹 Add Expense
  Future<void> addExpense(Expense expense) async {
    await ExpenseDB.insertExpense(expense);

    if (await _isOnline()) {
      await sync();
    }
  }

  // 🔹 Update Expense
  Future<void> updateExpense(Expense expense) async {
    await ExpenseDB.updateExpense(expense);

    if (await _isOnline()) {
      await sync();
    }
  }

  // 🔹 Delete Expense
  Future<void> deleteExpense(String id) async {
    await ExpenseDB.deleteExpense(id);

    // Optional: Also delete from Supabase if online
    if (await _isOnline()) {
      await _client.from('expenses').delete().eq('id', id);
    }
  }

  // 🔹 Upload single expense to Supabase
  Future<void> _uploadToSupabase(Expense expense) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      print("User not logged in, cannot sync");
      return;
    }

    await _client.from('expenses').upsert({
      'id': expense.id,
      'user_id': user.id, // 🔥 always use auth uid
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category,
      'created_at': expense.createdAt.toIso8601String(),
      'updated_at': expense.updatedAt.toIso8601String(),
    });
  }

  // 🔹 Fetch local expenses
  Future<List<Expense>> fetchExpenses() async {
    return await ExpenseDB.getExpenses();
  }

  // 🔹 Sync local → Supabase
  Future<void> sync() async {
    print("SYNC STARTED");

    if (!await _isOnline()) {
      print("OFFLINE");
      return;
    }

    final unsynced = await ExpenseDB.getUnsyncedExpenses();
    print("UNSYNCED COUNT: ${unsynced.length}");

    for (var expense in unsynced) {
      try {
        print("Uploading: ${expense.title}");

        await _uploadToSupabase(expense);

        await ExpenseDB.markAsSynced(expense.id);

        print("Marked synced: ${expense.id}");
      } catch (e) {
        print("Upload failed: $e");
      }
    }
  }
}
