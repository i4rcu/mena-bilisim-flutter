import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/widgets/admin_kullanici_ekle.dart';
import 'package:fitness_dashboard_ui/widgets/admin_kullanicilar_kart.dart';
import 'package:fitness_dashboard_ui/widgets/admin_rapor_ekle.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/widgets/raporlar_kart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardWidget extends StatelessWidget {
  const AdminDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminBloc(ApiHandler()),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Set mainAxisSize to min
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const KullanicilarKart(),
            const KullaniciEkleKart(),
            const RaporlarKart(),
            const RaporEkleKart(),
          ],
        ),
      ),
    );
  }
}