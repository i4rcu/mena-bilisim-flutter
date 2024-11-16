import 'package:fitness_dashboard_ui/admin_seide_menu/raporlar_sekme/raporlar.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RaporlarKart extends StatelessWidget {
  const RaporlarKart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(ApiHandler())..add(FetchRaporlar()),
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          String totalBakiyeText = 'Yükleniyor..';
          List<Raporlar> raporlar = [];

          if (state is RaporlarFetched) {
            totalBakiyeText = state.raporlar.length.toString();
            raporlar = state.raporlar;
          } else if (state is RaporlarFetchingError) {
            totalBakiyeText = 'Error: ${state.message}';
          }
          return Container(
            child: Column(
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildKasaCard(
                      context,
                      'Raporlar',
                      raporlar,
                      Color.fromRGBO(65, 190, 184, 20),
                      'Rapor Sayısı : $totalBakiyeText',
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
      List<Raporlar> raporlar, Color color, String toplam) {
    return Flexible( // Use Flexible instead of Expanded
      fit: FlexFit.tight, // Allow it to take only the space it needs
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      AdminBloc(ApiHandler())..add(FetchRaporlar()),
                ),
              ],
              child: RaporlarPage(),
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