import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/expense_view_model.dart';
import 'add_expense_page.dart';
import 'edit_expense_page.dart';

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExpenseViewModel>().loadExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total: ৳ ${vm.totalExpense.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          Column(
            children: vm.categories.map((c) {
              final total = vm.categoryTotal(c);
              if (total == 0) return const SizedBox();
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(c),
                    Text('৳ ${total.toStringAsFixed(2)}'),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(),

          Expanded(
            child: vm.expenses.isEmpty
                ? const Center(child: Text('No expenses'))
                : ListView.builder(
              itemCount: vm.expenses.length,
              itemBuilder: (_, i) {
                final e = vm.expenses[i];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text('${e.category} • ${e.date}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditExpensePage(expense: e),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon:
                        const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmed =
                          await showDeleteConfirmDialog(context);
                          if (confirmed == true) {
                            await vm.deleteExpense(e.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Expense deleted'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ➕ Add
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> showDeleteConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
