import 'package:flutter/material.dart';
import 'package:mvp_one/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(expense.title), // 提供默认值
                Text('${expense.time.toStringAsFixed(0)} 分钟'),
                // 使用`?`和`??`处理可能的null
                const Spacer(),
                Row(children: [
                  Icon(categoryIcons[expense.category] ?? Icons.error),
                  const SizedBox(width: 8),
                  Text(expense.formattedDate),
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }
}
