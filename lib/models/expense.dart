import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

// ignore: constant_identifier_names
enum Category { Upperbody, Lowerbody, Fullbody, other }

const categoryIcons = {
  Category.Upperbody: Icons.paragliding,
  Category.Lowerbody: Icons.airline_seat_legroom_extra,
  Category.Fullbody: Icons.accessibility_new,
  Category.other: Icons.self_improvement,
};

class Expense {
  Expense(
      {required this.title,
      required this.time,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double time;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpense {
    double sum = 0;

    for (final expense in expenses) {
      sum = sum + expense.time;
    }

    return sum;
  }
}
