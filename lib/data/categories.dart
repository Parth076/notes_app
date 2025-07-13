import 'package:flutter/material.dart';
import 'package:notes_app/model/category.dart';

const categories = {
  Categories.personal: Category(
    title: 'Personal',
    icon: Icons.account_circle_rounded,
  ),
  Categories.study: Category(title: 'Study', icon: Icons.menu_book_rounded),
  Categories.work: Category(title: 'Work', icon: Icons.business_center_rounded),
  Categories.ideas: Category(title: 'Ideas', icon: Icons.bubble_chart_rounded),
  Categories.others: Category(title: 'Others', icon: Icons.folder_open_rounded),
};
