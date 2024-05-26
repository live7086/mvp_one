// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Yoga {
  BOAT_POSE('船式'),
  COW_POSE('牛式'),
  Crescent_Lunge('新月式弓步'),
  Downward_Dog('下犬式'),
  Single_Leg_Downward_Facing_Dog('單腿下犬式'),
  TREE_POSE('樹式'),
  Upward_Facing_Dog_Pose('上犬式'),
  Warrior_I('戰士一式'),
  Warrior_II('戰士二式'),
  Warrior_III('戰士三式');

  final String chineseName;
  const Yoga(this.chineseName);

  static Yoga fromEnglishName(String englishName) {
    return Yoga.values.firstWhere(
      (yoga) => yoga.toString().split('.').last == englishName,
      orElse: () =>
          throw ArgumentError('Invalid yoga english name: $englishName'),
    );
  }
}

enum Category {
  Upperbody('上半身'),
  Lowerbody('下半身'),
  Fullbody('全身'),
  other('其他');

  final String chineseName;
  const Category(this.chineseName);
}

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
  final Yoga title;
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
