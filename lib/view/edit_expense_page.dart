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
    amountCtrl =
        TextEditingController(text: widget.expense.amount.toString());

    selectedCategory = widget.expense.category;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: titleCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Expense Title',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.currency_exchange),
                      prefixText: '৳ ',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: vm.categories
                        .map(
                          (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.update),
                      label: const Text(
                        'Update Expense',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final title = titleCtrl.text.trim();
                        final amount =
                            double.tryParse(amountCtrl.text) ?? 0;

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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
