import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/expense_view_model.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String selectedCategory = 'Food';

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
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
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Expense Title',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _amountController,
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
                      icon: const Icon(Icons.save),
                      label: const Text('Save Expense'),
                      onPressed: () {
                        final title = _titleController.text.trim();
                        final amount =
                            double.tryParse(_amountController.text) ?? 0;

                        if (title.isNotEmpty && amount > 0) {
                          vm.addExpense(title, amount, selectedCategory);
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
