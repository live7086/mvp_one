import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mvp_one/customize_menu/cus_menu.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/screens/allMainPages.dart';
import 'package:mvp_one/user/UserInformationPage.dart';
import 'package:mvp_one/widget_expense/chart/chart.dart';
import 'package:mvp_one/widget_expense/expenses_list/expenses_list.dart';
import 'package:mvp_one/models/expense.dart';
import 'package:mvp_one/widget_expense/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key, required this.uid});

  final String uid;

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  int _selectedPageIndex = 2;
  List<Expense> _registeredExpenses = [];

  @override
  void initState() {
    super.initState();
    _fetchExpensesFromDatabase();
  }

  Future<void> _fetchExpensesFromDatabase() async {
    final databaseURL = 'https://flutter-dogshit-default-rtdb.firebaseio.com';
    final databasePath = 'user-training';

    final database = FirebaseDatabase(databaseURL: databaseURL).reference();
    final snapshot = await database
        .child(databasePath)
        .orderByChild('uid')
        .equalTo(widget.uid)
        .once();

    final expenses = <Expense>[];
    if (snapshot.snapshot.value is Map) {
      (snapshot.snapshot.value as Map).forEach((key, value) {
        if (value is Map) {
          final expenseData = value;
          final expense = Expense(
            title:
                Yoga.values.firstWhere((e) => e.name == expenseData['title']),
            time: double.parse(expenseData['time'].toString()),
            date: DateTime.parse(expenseData['date']),
            category: Category.values
                .firstWhere((e) => e.name == expenseData['category']),
          );
          expenses.add(expense);
        }
      });
    }

    if (mounted) {
      setState(() {
        _registeredExpenses = expenses;
      });
    }
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
        uid: widget.uid,
      ),
    );
    print("接收到的UID: ${widget.uid}");
  }

  void _addExpense(Expense expense) {
    if (mounted) {
      setState(() {
        _registeredExpenses.add(expense);
      });
    }
  }

  bool _isCancelled = false;

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    _isCancelled = false; // 重置取消標誌

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認刪除'),
          content: const Text('你確定要刪除這個項目嗎?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isCancelled = true; // 設置取消標誌為 true
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (!_isCancelled) {
                  // 檢查取消標誌
                  setState(() {
                    _registeredExpenses.remove(expense);
                  });
                  _deleteExpenseFromDatabase(expense);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      content: const Text('運動紀錄'),
                      action: SnackBarAction(
                        label: '復原',
                        onPressed: () {
                          setState(() {
                            _registeredExpenses.insert(expenseIndex, expense);
                          });
                          _addExpenseToDatabase(expense);
                        },
                      ),
                    ),
                  );
                }
              },
              child: const Text('確認'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteExpenseFromDatabase(Expense expense) async {
    final databaseURL = 'https://flutter-dogshit-default-rtdb.firebaseio.com';
    final databasePath = 'user-training';

    final database = FirebaseDatabase(databaseURL: databaseURL).reference();
    final query =
        database.child(databasePath).orderByChild('uid').equalTo(widget.uid);

    final snapshot = await query.once();
    if (snapshot.snapshot.value is Map) {
      (snapshot.snapshot.value as Map).forEach((key, value) {
        if (value is Map) {
          final expenseData = value;
          if (expenseData['title'] == expense.title.name &&
              expenseData['time'] == expense.time &&
              expenseData['date'] == expense.date.toIso8601String() &&
              expenseData['category'] == expense.category.name) {
            database.child(databasePath).child(key).remove();
          }
        }
      });
    }
  }

  Future<void> _addExpenseToDatabase(Expense expense) async {
    final databaseURL = 'https://flutter-dogshit-default-rtdb.firebaseio.com';
    final databasePath = 'user-training';

    final database = FirebaseDatabase(databaseURL: databaseURL).reference();
    final newExpenseRef = database.child(databasePath).push();

    await newExpenseRef.set({
      'title': expense.title.name,
      'time': expense.time,
      'date': expense.date.toIso8601String(),
      'category': expense.category.name,
      'uid': widget.uid,
    });
  }

  void _selectPage(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TabsScreen(
            uid: widget.uid,
          ),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomizeMenuPage(uid: widget.uid),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Expenses(
            uid: widget.uid,
          ),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserInformationPage(uid: widget.uid),
        ));
        break;
      default:
        setState(() {
          _selectedPageIndex = index;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('沒有訓練紀錄 請按 + 新增紀錄'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
            iconSize: 36.0,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 在這裡取消訂閱或停止任何計時器或動畫
    super.dispose();
  }
}
