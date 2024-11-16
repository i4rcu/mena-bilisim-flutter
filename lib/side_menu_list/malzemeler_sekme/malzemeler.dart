import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/faturla.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/en_cok_satilan_malzeme.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/gunluk_malzeme_alisi.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/gunluk_malzeme_satisi.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/satilan_malzemeler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/tum_malzemeler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';

class MalzemelerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 55, 69, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(35, 55, 69, 1),
        title: Text(
          'Malzemeler',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 16.0, // Spacing between columns
          mainAxisSpacing: 16.0, // Spacing between rows
          childAspectRatio: 3 / 2, // Aspect ratio for card (adjust as needed)
          children: [
            _buildMenuCard(
              context,
              title: 'Hareket Görmeyen Malzemeler',
              color: Color.fromRGBO(65, 190, 184, 1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) =>
                          MalzemelerBloc(ApiHandler())..add(FetchHmalzeme()),
                      child: AllItemsPage(),
                    ),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Hangi Malzeme Kime Satıldı',
              color: Color.fromRGBO(241, 108, 39, 1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(FetchSatilanMalzeme()),
                      child: SatilanMalzemePage(),
                    ),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Tüm Malzemeler',
              color: Color.fromRGBO(59, 180, 115, 1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchTumMalzemeler()),
                      child: TumMalzemelerPage(),
                    ),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'En Çok Satılan Malzemeler',
              color: Color.fromRGBO(123, 104, 238, 1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchEnCokSatilanMalzemeler("","","0")),
                      child: EnCokSatilanMalzemeListPage(),
                    ),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Günlük Malzeme Satışı',
              color: Color.fromRGBO(255, 159, 64, 1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchGunlukMalzemeSatisi("","","0")),
                      child: GunlukMalzemeSatisiListPage(),
                    ),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Günlük Malzeme Alışı',
              color: Color.fromRGBO(2, 144, 154, 1),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchGunlukMalzemeAlisi("","","0")),
                      child: GunlukMalzemeAlisiListPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
