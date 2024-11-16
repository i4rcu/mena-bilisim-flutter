import 'package:fitness_dashboard_ui/admin_seide_menu/kullanicilar_sekme/kullanicilar.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KullanicilarKart extends StatelessWidget {
  const KullanicilarKart({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        BlocProvider(
          create: (context) =>
              AdminBloc(ApiHandler())..add(FetchKullanicilar()),
        
        
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
                      'Tüm Kullanicilar',
                      kullanicilar,
                      Color.fromRGBO(59, 180, 115, 20),
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
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      AdminBloc(ApiHandler())..add(FetchKullanicilar()),
                ),
              ],
              child: KullanicilarPage(),
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
                    'Ayrıntılar için tıklayın',
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