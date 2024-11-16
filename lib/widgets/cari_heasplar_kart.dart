import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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

        return Expanded(
          child: Container(
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
          ),
        );
      },
    );
  }

  Widget _buildKasaCard(BuildContext context, String title,
      List<CariHesap> cariHesaplar, Color color, String toplam, bool isDesktop) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showKasaListPopup(context, cariHesaplar, isDesktop),
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

  void _showKasaListPopup(BuildContext context, List<CariHesap> cariHesaplar, bool isDesktop) {
  final formatter = NumberFormat('#,##0.00', 'tr_TR');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromRGBO(36, 64, 72, 50),
        title: Text(
          'Cari Hesaplar',
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 20 : 16, // Larger font size for desktop
          ),
        ),
        content: Container(
          height: 400,
          width: double.maxFinite,
          child: cariHesaplar.isEmpty
              ? Center(
                  child: Text(
                    'Henüz herhangi bir cari hesap bilgisi girilmemiştir.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 18 : 14, // Larger font size for desktop
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: cariHesaplar.length,
                  itemBuilder: (context, index) {
                    final hesap = cariHesaplar[index];
                    final bakiye = hesap.bakiye ?? 0.0;
                    final bakiyeTextColor = bakiye >= 0
                        ? Colors.green.shade400
                        : Color.fromARGB(255, 255, 20, 3);
                    final formattedBakiye = formatter.format(bakiye.abs());
                    final bakiyeText = bakiye >= 0
                        ? '$formattedBakiye (B)'
                        : '$formattedBakiye (A)';

                    return ListTile(
                      title: Text(
                        hesap.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 18 : 14, // Larger font size for desktop
                        ),
                      ),
                      subtitle: Text(
                        'Bakiye: $bakiyeText',
                        style: TextStyle(
                          color: bakiyeTextColor,
                          fontSize: isDesktop ? 16 : 12, // Larger font size for desktop
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Kapat',
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 16 : 12, // Larger font size for desktop
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
