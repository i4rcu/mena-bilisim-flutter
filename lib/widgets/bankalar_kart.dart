import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/side_menu_list/bankalar_sekme/bankalar_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bankalar_bloc/bankalar_bloc.dart';
import 'package:intl/intl.dart';

class BankalarKart extends StatelessWidget {
  final bool isDesktop;

  const BankalarKart({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankalarBloc, BankalarState>(
      builder: (context, state) {
        String totalBakiyeText = 'Yükleniyor..';
        List<Banka> bankalar = [];
        final formatter1 = NumberFormat('#,##0.00', 'tr_TR');

        if (state is BankalarLoaded) {
          totalBakiyeText = formatter1
              .format(state.Bankalar.fold(0.0, (sum, banka) => sum + banka.bakiye!))
              .toString();
          bankalar = state.Bankalar;
        } else if (state is BankalarError) {
          totalBakiyeText = 'Error: ${state.message}';
        }

        return Container(
          width: isDesktop ? 800 : 550, // Wider container for desktop
          child: Column(
            children: [
              SizedBox(height: isDesktop ? 16 : 8), // Adjusted height for desktop
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildKasaCard(
                    context,
                    'Tüm Bankalar',
                    bankalar,
                    Color.fromRGBO(59, 180, 115, 20),
                    'Toplam Bakiye: ${totalBakiyeText}',
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
      List<Banka> bankalar, Color color, String toplam, bool isDesktop) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => BankalarBloc(ApiHandler()),
              child: BankalarListPage(),
            ),
          ),
        ),
        child: Card(
          color: color,
          elevation: 5,
          margin: EdgeInsets.all(isDesktop ? 13 : 5), // Adjusted margin for desktop
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20.0 : 15.0), // Adjusted padding for desktop
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
                SizedBox(height: isDesktop ? 20 : 10), // Adjusted height for desktop
                Text(
                  toplam,
                  style: TextStyle(
                    fontSize: isDesktop ? 16 : 14, // Larger font size for desktop
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isDesktop ? 16 : 10), // Adjusted height for desktop
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