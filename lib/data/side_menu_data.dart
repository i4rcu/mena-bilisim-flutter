import 'package:flutter/material.dart';

class MenuModel {
  final IconData icon;
  final String title;
  final List<String>? subMenu; // Optional list for sub-menu items

  const MenuModel({
    required this.icon,
    required this.title,
    this.subMenu, // Sub-menu can be null for main menu items without sub-items
  });
}

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.person, title: 'Cari Hesaplar', subMenu: [
      'Cari Hesaplar',
      'En Çok Satış Yapılan Cari Hesaplar Turar Bazlı',
    ]),
    MenuModel(icon: Icons.agriculture_rounded, title: 'Malzemeler', subMenu: [
      'Hareket Görmeyen Malzemeler',
      'Hangi Malzeme Kime Satıldı',
      "Tüm Malzemeler",
      "En Çok Satılan Mazlemeler",
      "Günlük Malzeme Satışı",
      "Günlük Malzeme Alışı"
    ]),
    MenuModel(icon: Icons.payment, title: 'Alış Faturaları'),
    MenuModel(icon: Icons.sell, title: 'Satış Faturaları'),
    MenuModel(icon: Icons.money, title: 'Bankalar'),
    MenuModel(icon: Icons.settings, title: 'Çek Ve Senet'),
    MenuModel(icon: Icons.receipt_long_sharp, title: 'Raporlar'),
  ];
}

