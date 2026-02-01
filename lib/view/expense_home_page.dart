import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/category_colors.dart';
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

  // 📅 Month name helper
  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // 📅 Month selector
  Widget _monthSelector(ExpenseViewModel vm) {
    final year = DateTime.now().year;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Month', style: TextStyle(fontWeight: FontWeight.w600)),
          DropdownButton<DateTime>(
            value: vm.selectedMonth,
            underline: const SizedBox(),
            items: List.generate(12, (i) {
              final date = DateTime(year, i + 1);
              return DropdownMenuItem(
                value: date,
                child: Text('${_monthName(date.month)} $year'),
              );
            }),
            onChanged: (value) {
              if (value != null) {
                vm.changeMonth(value);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // 🔝 APP BAR (Cleaner)
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 🔝 TOTAL SUMMARY (Premium Card)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B6EE1), Color(0xFF7C8CF4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: .25),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'This Month',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '৳ ${vm.filteredTotalExpense.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 📅 MONTH SELECTOR
            _monthSelector(vm),
            const SizedBox(height: 10),

            // 🏷 CATEGORY ANALYTICS (Refined)
            if (vm.filteredExpenses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: vm.categories.map((c) {
                    final total = vm.filteredCategoryTotal(c);
                    if (total == 0) return const SizedBox();

                    final percent = vm.filteredTotalExpense == 0
                        ? 0.0
                        : total / vm.filteredTotalExpense;

                    final color = CategoryColors.get(c);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '৳ ${total.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percent,
                              minHeight: 8,
                              backgroundColor: color.withValues(alpha: .15),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 14),

            // 📋 EXPENSE LIST
            vm.filteredExpenses.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No expenses for this month',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true, // 🔥 MUST
                    physics: const NeverScrollableScrollPhysics(), // 🔥 MUST
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
                    itemCount: vm.filteredExpenses.length,
                    itemBuilder: (_, i) {
                      final e = vm.filteredExpenses[i];
                      final color = CategoryColors.get(e.category);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .04),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(Icons.receipt_long, color: color),
                          ),
                          title: Text(
                            e.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${e.category} • ${e.date}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min, // 🔥 KEY FIX
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '৳ ${e.amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditExpensePage(expense: e),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16, // 🔥 smaller
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () async {
                                      final confirmed =
                                      await showDeleteConfirmDialog(context);
                                      if (confirmed == true) {
                                        await vm.deleteExpense(e.id!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Expense deleted')),
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      size: 16, // 🔥 smaller
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),

      // ➕ FAB (Modern)
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: const Color(0xFF5B6EE1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpensePage()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // 🗑 Confirm dialog
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
