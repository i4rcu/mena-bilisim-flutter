import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_detail_page.dart';

class EnCokSatilanCariHesapListPage extends StatefulWidget {
  @override
  _EnCokSatilanCariHesapListPageState createState() =>
      _EnCokSatilanCariHesapListPageState();
}

class _EnCokSatilanCariHesapListPageState
    extends State<EnCokSatilanCariHesapListPage> {
  String _searchQuery = '';
  DateTime _selectedDate =
      DateTime(DateTime.now().year, 1, 1); // Initialize later
  int daysDifference = 0;

  @override
  void initState() {
    super.initState();
    // Set the default value to January 1 of the current year
    _selectedDate = DateTime(DateTime.now().year, 1, 1);
    daysDifference = DateTime.now()
        .difference(_selectedDate)
        .inDays; // Calculate initial days difference
    // Fetch the initial data
    BlocProvider.of<CariHesapBloc>(context).add(
      fetchEnCokSatilanCairler(
          "tablePrefix", "tableSuffix", daysDifference.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.87)), // Force text scale factor to 1.0
    child: SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(35, 55, 69, 10),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromRGBO(35, 55, 69, 10),
            title: Text(
              'En Çok Satış Yapılan Cari Hesaplar Tutar Bazlı',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(130),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
        fillColor: Color.fromRGBO(56, 74, 82, 1),
                        labelText: 'Ara',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(68, 192, 186, 10)),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(68, 192, 186, 10), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query.toLowerCase();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Tarih Seç:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              locale: Locale('tr', 'TR'),
                              initialDate: _selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              helpText: 'Tarih Seç',
                            );
                            if (pickedDate != null && pickedDate != _selectedDate) {
                              setState(() {
                                _selectedDate = pickedDate;
                                daysDifference = DateTime.now()
                                    .difference(_selectedDate)
                                    .inDays; // Recalculate days difference
                              });
                              // Trigger the Bloc event with the new daysDifference
                              BlocProvider.of<CariHesapBloc>(context).add(
                                fetchEnCokSatilanCairler("tablePrefix",
                                    "tableSuffix", daysDifference.toString()),
                              );
                            }
                          },
                          child: Text(
                            "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Color.fromRGBO(68, 192, 186, 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: BlocBuilder<CariHesapBloc, CariHesapState>(
            builder: (context, state) {
              if (state is CariHesapInitial) {
                return Center(child: Text('Listelenecek kayıt yok'));
              } else if (state is EnCokSatilanCarilerLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is EnCokSatilanCarilerLoaded) {
                List<EnCokSatilanCariler> filteredCariHesaplar;
        
                if (_searchQuery.isEmpty) {
                  filteredCariHesaplar = state.enCokSatilanCariler;
                } else {
                  filteredCariHesaplar =
                      state.enCokSatilanCariler.where((cariHesap) {
                    return cariHesap.name!.toLowerCase().contains(_searchQuery);
                  }).toList();
                }
        
                return ListView.builder(
                  itemCount: filteredCariHesaplar.length,
                  itemBuilder: (context, index) {
                    final cariHesap = filteredCariHesaplar[index];
                    final isNegative = cariHesap.tutar! < 0;
                    return Card(
                      color: Color.fromRGBO(45, 65, 80, 50),
                      margin: EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        title: Text(
                          cariHesap.name!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          '${cariHesap.tutar!.toStringAsFixed(2)} ${isNegative ? "(A)" : "(B)"}',
                          style: TextStyle(
                            color: isNegative
                                ? Color.fromARGB(255, 255, 20, 3)
                                : Color.fromRGBO(47, 175, 107, 20),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CariHesapDetailPage(
                                  logicalref: cariHesap.logicalref!),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else if (state is CariHesapError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return Container(
                width: 300,
                height: 300,
                color: Colors.white,
              );
            },
          ),
        ),
    ),
    );
  }
}
