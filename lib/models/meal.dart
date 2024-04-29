import 'dart:core';

import 'package:flutter/material.dart';

enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

class Meal {
  const Meal({
    required this.id,
    required this.categories,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
    required this.videoUrl,
    required this.istime1,
    required this.istime2,
    required this.islevel1,
    required this.islevel2,
    required this.islevel3,
  });

  final String id;
  final List<String> categories;
  final String title;
  final AssetImage imageUrl;
  final String videoUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
  final bool istime1;
  final bool istime2;
  final bool islevel1;
  final bool islevel2;
  final bool islevel3;
}
