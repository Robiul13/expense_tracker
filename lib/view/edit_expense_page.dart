import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/expense_model.dart';
import '../viewmodel/expense_view_model.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense;

  const EditExpensePage({super.key, required this.expense});

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  late TextEditingController titleCtrl;
  late TextEditingController amountCtrl;

  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.expense.title);
    amountCtrl = TextEditingController(text: widget.expense.amount.toString());

    selectedCategory = widget.expense.category;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// TITLE
                TextFormField(
                  controller: titleCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Expense Title',
                    prefixIcon: const Icon(Icons.description_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// AMOUNT
                TextFormField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: const Icon(Icons.currency_exchange),
                    prefixText: '৳ ',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// CATEGORY
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: vm.categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),

                const SizedBox(height: 30),

                /// UPDATE BUTTON
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B6EE1),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () async {
                      final title = titleCtrl.text.trim();
                      final amount = double.tryParse(amountCtrl.text) ?? 0;

                      if (title.isNotEmpty && amount > 0) {
                        await vm.updateExpense(
                          widget.expense,
                          title,
                          selectedCategory,
                          amount,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text(
                      'Update Expense',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
