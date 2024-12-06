import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_state.dart';
import 'package:intl/intl.dart';

class ActivityDetailsCard extends StatelessWidget {
  final bool isDesktop;

  const ActivityDetailsCard({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownBloc, DropdownState>(
      builder: (context, state) {
        String totalBakiyeText = 'Yükleniyor..';
        List<KasaDto> kasalar = [];

        final formatter1 =
            NumberFormat('#,##0.00', 'tr_TR'); // Ensure zero is handled as 0.00
        if (state is DropdownLoaded) {
          final formattedTotal = formatter1.format(state.totalBakiye);
          totalBakiyeText = 'Toplam Bakiye: ${formattedTotal}';
          kasalar = state.kasalar ?? [];
        } else if (state is DropdownError) {
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
                    'Tüm Kasalar',
                    kasalar,
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

  Widget _buildKasaCard(BuildContext context, String title, List<KasaDto> kasalar,
      Color color, String toplam, bool isDesktop) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showKasaListPopup(context, kasalar, isDesktop),
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

  void _showKasaListPopup(BuildContext context, List<KasaDto> kasalar, bool isDesktop) {
  final formatter = NumberFormat('#,##0.00', 'tr_TR'); // Ensure zero is handled as 0.00

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromRGBO(36, 64, 72, 50),
        title: Text(
          'Kasalar',
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 20 : 16, // Larger font size for desktop
          ),
        ),
        content: Container(
          height: 400,
          width: double.maxFinite,
          child: kasalar.isEmpty
              ? Center(
                  child: Text(
                    'Henüz herhangi bir kasa bilgileri girilmemiştir.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 18 : 14, // Larger font size for desktop
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: kasalar.length,
                  itemBuilder: (context, index) {
                    final kasa = kasalar[index];
                    final bakiye = kasa.bakiye;
                    final bakiyeTextColor = bakiye >= 0
                        ? Colors.green.shade400
                        : Color.fromARGB(255, 255, 20, 3);
                    final formattedBakiye = formatter.format(bakiye.abs());
                    final bakiyeText = bakiye >= 0
                        ? '$formattedBakiye (B)'
                        : '$formattedBakiye (A)';

                    return ListTile(
                      title: Text(
                        kasa.name,
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