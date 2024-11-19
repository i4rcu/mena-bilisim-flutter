import 'package:fitness_dashboard_ui/admin_seide_menu/ekle.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KullaniciEkleKart extends StatelessWidget {
  const KullaniciEkleKart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(ApiHandler())..add(FetchKullanicilar()),
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          String totalKullaniciSayisi = 'Yükleniyor..';

          List<Kullanicilar> kullanicilar = [];

          if (state is KullanicilarLoaded) {
            totalKullaniciSayisi = state.kullanicilar.length.toString();
            kullanicilar = state.kullanicilar;
          } else if (state is KullanicilarError) {
            totalKullaniciSayisi = 'Error: ${state.message}';
          }
          return Container(
            width: 550,
            child: Column(
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildKasaCard(
                      context,
                      'Kullanici Ekle',
                      kullanicilar,
                      Color.fromRGBO(241, 108, 39, 20),
                      'Toplam Kullanıcı Sayısı : $totalKullaniciSayisi',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKasaCard(BuildContext context, String title,
      List<Kullanicilar> kullanicilar, Color color, String toplam) {
    return Flexible( // Use Flexible instead of Expanded
      fit: FlexFit.tight, // Allow it to take only the space it needs
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => AdminBloc(ApiHandler()),
              child: KullaniciEkle(),
            ),
          ),
        ),
        child: Container(
          height: 150,
          child: Card(
            color: color,
            elevation: 5,
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  /*Text(
                    toplam,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  */Text(
                    'Eklemek İçin Tıklayınız',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[850],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}