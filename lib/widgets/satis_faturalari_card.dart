import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/alinan_faturala_bloc/alinan_faturalar_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/satis.faturalari.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SatisFaturalari extends StatelessWidget {
  final bool isDesktop;

  const SatisFaturalari({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlinanFaturalarBloc, AlinanFaturalarState>(
      builder: (context, state) {
        String totalBakiyeText = 'Yükleniyor..';
        print(state.toString());
        if (state is AlinanAndSatisFaturalarLoadSuccess ) {
          totalBakiyeText = 'Toplam Fatura Sayısı: ${state.satisFaturalar.length}';
        } else if (state is SatisFaturaLoadFailure) {
          totalBakiyeText = 'Error: ${state.error}';
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
                    'Satış Faturaları',
                    Color.fromRGBO(241, 108, 39, 20),
                    '${totalBakiyeText}',
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
      Color color, String toplam, bool isDesktop) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => AlinanFaturalarBloc(ApiHandler()),
              child: SatisFaturalarPage(),
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