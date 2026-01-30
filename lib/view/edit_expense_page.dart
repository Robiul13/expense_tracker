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

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.expense.title);
    amountCtrl = TextEditingController(text: widget.expense.amount.toString());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ExpenseViewModel>();
    String selectedCategory = 'Food';
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              items: vm.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleCtrl.text;
                final amount = double.tryParse(amountCtrl.text) ?? 0;

                if (title.isNotEmpty && amount > 0) {
                  await vm.updateExpense(
                    widget.expense.id!,
                    title,
                    selectedCategory,
                    amount,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
