import 'package:flutter/material.dart';

class AdminMenuModel {
  final IconData icon;
  final String title;
  final List<String>? subMenu; // Optional list for sub-menu items

  const AdminMenuModel({
    required this.icon,
    required this.title,
    this.subMenu, // Sub-menu can be null for main menu items without sub-items
  });
}

class AdminSideMenuData {
  final menu = const <AdminMenuModel>[
    AdminMenuModel(icon: Icons.person, title: 'Kullanıcılar'),
    AdminMenuModel(icon: Icons.person_add_alt_1, title: 'Yeni Kullanıcı'),
    AdminMenuModel(icon: Icons.assessment_rounded, title: 'Raporlar'),
    AdminMenuModel(icon: Icons.logout, title: 'Çıkış'),
    
  ];
}

