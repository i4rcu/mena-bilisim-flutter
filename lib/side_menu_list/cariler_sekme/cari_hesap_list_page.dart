import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CariHesapListPage extends StatefulWidget {
  @override
  _CariHesapListPageState createState() => _CariHesapListPageState();
}

class _CariHesapListPageState extends State<CariHesapListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 55, 69, 10),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        title: Text(
          'Müşteriler',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Ara',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(
                          68, 192, 186, 10),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(
                          47, 175, 107, 20), 
                      width: 2.0, 
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
              )),
        ),
      ),
      body: BlocProvider(
        create: (context) => CariHesapBloc(ApiHandler())
          ..add(FetchCariHesaplar('yourTablePrefix', 'yourTableSuffix')),
        child: BlocBuilder<CariHesapBloc, CariHesapState>(
          builder: (context, state) {
            if (state is CariHesapInitial) {
              return Center(child: Text('Listelenecek kayıt yok'));
            } else if (state is CariHesapLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CariHesapLoaded) {
              final filteredCariHesaplar =
                  state.cariHesaplar.where((cariHesap) {
                return cariHesap.name.toLowerCase().contains(_searchQuery) ||
                    cariHesap.code.toLowerCase().contains(_searchQuery);
              }).toList();

              return ListView.builder(
                itemCount: filteredCariHesaplar.length,
                itemBuilder: (context, index) {
                  final cariHesap = filteredCariHesaplar[index];
                  final isNegative = cariHesap.bakiye < 0;
                  return Card(
                    color: Color.fromRGBO(45, 65, 80, 50),
                    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cariHesap.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          Text(
                            cariHesap.code,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '${cariHesap.bakiye.toStringAsFixed(2)} ${isNegative ? "(A)" : "(B)"}',
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
                              logicalref: cariHesap.logicalRef,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is CariHesapError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
