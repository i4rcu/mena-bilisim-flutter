// cari_hesap_page.dart
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_list_page.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/en_cok_satilan_cariler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// cari_hesap_page.dart

class CariHesapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => CariHesapBloc(ApiHandler())..add(fetchEnCokSatilanCairler("tablePrefix", "tableSuffix", "1")),
      child:  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(35, 55, 69, 10),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromRGBO(35, 55, 69, 10),
            title: Text(
              'Cari Hesaplar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMenuCard(
                  context,
                  title: "Cari Hesaplar",
                  color: Color.fromRGBO(65, 190, 184, 20), // First card color
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CariHesapListPage()),
                      );
                    },
                ),
                SizedBox(height: screenHeight * 0.02),
                 _buildMenuCard(
                  context,
                  title: "En Çok Satış Yapılan Cari Hesaplar Tutar Bazlı",
                  color:Color.fromRGBO(241, 108, 39, 20), 
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => CariHesapBloc(ApiHandler())..add(
                          fetchEnCokSatilanCairler("tablePrefix", "tableSuffix", "0"), // Replace with actual parameters
                        ),
                        child: EnCokSatilanCariHesapListPage(),
                      ),
                    ),
                  );
                },
        
                ),
                SizedBox(height: screenHeight * 0.02),
                 _buildMenuCard(
                  context,
                  title: "Cari Hesaplar",
                  color: Color.fromRGBO(59, 180, 115, 20), // Third card color
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CariHesapListPage()),
                      );
                    },
                ),
                  
                
              ],
            ),
          ),
        ),
      ),
    ));
  }
  Widget _buildMenuCard(BuildContext context, {required String title, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color, 
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
