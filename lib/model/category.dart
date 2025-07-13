import 'package:flutter/material.dart';

enum Categories { personal, work, ideas, study, others }

class Category {
  const Category({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
