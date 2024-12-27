import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CariHeasplarKart extends StatelessWidget {
  final bool isDesktop;

  const CariHeasplarKart({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CariHesapBloc, CariHesapState>(
      builder: (context, state) {
        String totalBakiyeText = 'Yükleniyor..';
        List<CariHesap> cariHesaplar = [];

        if (state is CariHesapLoaded) {
          totalBakiyeText = state.cariHesaplar.length.toString();
          cariHesaplar = state.cariHesaplar;
        } else if (state is CariHesapError) {
          totalBakiyeText = 'Error: ${state.message}';
        }

        return Container(
          child: Column(
            children: [
              SizedBox(height: isDesktop ? 16 : 8), // Larger spacing for desktop
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildKasaCard(
                    context,
                    'Cari Hesaplar',
                    cariHesaplar,
                    Color.fromRGBO(65, 190, 184, 20),
                    'Hesap Sayısı: ${totalBakiyeText}',
                    isDesktop,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKasaCard(BuildContext context, String title,
      List<CariHesap> cariHesaplar, Color color, String toplam, bool isDesktop) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CariHesapBloc(ApiHandler()),
            child: CariHesapListPage(),
          ),
        ),
      ),
        child: Card(
          color: color,
          elevation: 5,
          margin: EdgeInsets.all(isDesktop ? 13 : 5), // Larger margin for desktop
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20.0 : 15.0), // Larger padding for desktop
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 20 : 16, // Larger font size for desktop
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isDesktop ? 20 : 10), // Larger spacing for desktop
                Text(
                  toplam,
                  style: TextStyle(
                    fontSize: isDesktop ? 16 : 12, // Larger font size for desktop
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isDesktop ? 16 : 10), // Larger spacing for desktop
                Text(
                  'Ayrıntılar için tıklayın',
                  style: TextStyle(
                    fontSize: isDesktop ? 16 : 12, // Larger font size for desktop
                    color: Colors.grey[850],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  

}