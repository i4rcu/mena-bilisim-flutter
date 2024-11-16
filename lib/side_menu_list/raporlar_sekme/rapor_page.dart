import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/raporlar_sekme/data_table_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 54, 69, 20),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(36, 64, 72, 1),
        title: Text('Raporlar'),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is KullaniciRaporFetching) {
            return Center(child: CircularProgressIndicator());
          } else if (state is KullaniciRaporFetched) {
            List<Raporlar> raporlar = state.raporlar;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of cards per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1, // Adjust aspect ratio for card size
              ),
              itemCount: raporlar.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color.fromRGBO(36, 64, 72, 1),
                  child: InkWell(
                    onTap: () {
                      // When a report card is tapped, fetch data for the selected report
                      _fetchReportData(raporlar[index].raporSorgusu!, raporlar[index].raporAdi!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          raporlar[index].raporAdi!,
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is KullaniciRaporFetchError) {
            return Center(child: Text('Failed to load reports.'));
          }
          return Center(child: Text('No reports available.'));
        },
      ),
    );
  }

  // Method to fetch report data based on the selected report's query
  Future<void> _fetchReportData(String raporSorgusu, String raporAdi) async {
        final prefs = await SharedPreferences.getInstance();

    try {
      // Call your API handler to fetch the data
      final result = await ApiHandler().getDataTableForReport(raporSorgusu,prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '');
      
      // If result is not null and contains data, navigate to the data table page
      if (result.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ReportDataPage(data: result, name: raporAdi),
          ),
        );
      } else {
        // If no data is available, show a snack bar with a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No data available for the selected report.')),
        );
      }
    } catch (error) {
      // Handle any errors during fetching the data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch report data.')),
      );
    }
  }
}
