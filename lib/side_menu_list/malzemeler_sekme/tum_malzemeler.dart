import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:intl/intl.dart';

class TumMalzemelerPage extends StatefulWidget {
  @override
  _TumMalzemelerPageState createState() => _TumMalzemelerPageState();
}

class _TumMalzemelerPageState extends State<TumMalzemelerPage> {
  String _searchQuery = '';
  final formatter1 = NumberFormat('#,##0.00', 'tr_TR');

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
    });
    BlocProvider.of<MalzemelerBloc>(context).add(fetchTumMalzemeler());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 55, 69, 10),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        title: Text(
          'Tüm Malzemeler',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetFilters,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Ara',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(68, 192, 186, 10),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(65, 190, 184, 20),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => MalzemelerBloc(ApiHandler())..add(fetchTumMalzemeler()),
        child: BlocBuilder<MalzemelerBloc, MalzemelerState>(
          builder: (context, state) {
            if (state is MalzemelerInitial) {
              return Center(child: Text('Listelenecek kayıt yok'));
            } else if (state is TumMalzemeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TumMalzemeloaded) {
              // Filter the list by search query (search in both 'name' and 'code')
              final filteredItems = state.TUMMALZEMELERR.where((item) {
                return item.name!.toLowerCase().contains(_searchQuery) ||
                    item.code!.toLowerCase().contains(_searchQuery);
              }).toList();

              return ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final cariHesap = filteredItems[index];

                  // Determine color and formatting for 'elde'
                  final isNegative = cariHesap.elde! < 0;
                  final eldeText = formatter1.format(cariHesap.elde?.abs());
                  final eldeColor = isNegative
                      ? Colors.red // Red for negative values
                      : Color.fromRGBO(85, 185, 180, 20); // Green for positive

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Color.fromRGBO(45, 65, 80, 50),
                      child: ListTile(
                        title: Text(
                          cariHesap.name ?? '',
                          style: TextStyle(
                              color: Color.fromRGBO(85, 185, 180, 20),
                              fontSize: 19),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cariHesap.code}',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$eldeText Adet',
                              style: TextStyle(color: eldeColor, fontSize: 19),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is TumMalzemeError) {
              return Center(child: Text('Veri Yüklenemedi'));
            } else {
              return Center(child: Text('Beklenmedik bir hata oluştu'));
            }
          },
        ),
      ),
    );
  }
}
