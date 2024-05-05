import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mvp_one/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense, required this.uid});

  final void Function(Expense expense) onAddExpense;
  final String uid;
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  late var _titleController = Yoga.TREE_POSE;
  final _timeController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.other;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredTime = double.tryParse(_timeController.text);
    final timeIsInvalid = enteredTime == null || enteredTime <= 0;

    final expense = Expense(
      title: _titleController,
      time: enteredTime ?? 0.0,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    _saveExpenseToDatabase(expense);

    widget.onAddExpense(expense);
    Navigator.pop(context);
  }

  void _saveExpenseToDatabase(Expense expense) {
    final databaseURL = 'https://flutter-dogshit-default-rtdb.firebaseio.com';
    final databasePath = 'user-training';

    final database = FirebaseDatabase(databaseURL: databaseURL).reference();
    final newExpenseRef = database.child(databasePath).push();

    newExpenseRef.set({
      'title': expense.title.name,
      'time': expense.time,
      'date': expense.date.toIso8601String(),
      'category': expense.category.name,
      'uid': widget.uid,
    }).then((_) {
      print('訓練紀錄寫入成功');
    }).catchError((error) {
      print('寫入訓練紀錄時發生錯誤: $error');
    });
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          DropdownButton(
              value: _titleController,
              items: Yoga.values
                  .map(
                    (title) => DropdownMenuItem(
                      value: title,
                      child: Text(
                        title.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _titleController = value;
                });
                print(value);
              }),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time_outlined),
                    label: Text('訓練時長'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? '尚未選取日期！'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                    print(value);
                  }),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('新增'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
