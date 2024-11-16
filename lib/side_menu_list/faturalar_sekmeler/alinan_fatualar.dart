import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/fatura_detay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/alinan_faturala_bloc/alinan_faturalar_bloc.dart';
import 'package:intl/intl.dart';

class AlinanFaturalarPage extends StatefulWidget {
  @override
  _AlinanFaturalarPageState createState() => _AlinanFaturalarPageState();
}

class _AlinanFaturalarPageState extends State<AlinanFaturalarPage> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortBy = 'Tarih';
  bool _isAscending = true;
  final formatter1 = NumberFormat('#,##0.00', 'tr_TR');
  final DateFormat _displayDateFormat = DateFormat('dd.MM.yyyy');
  final DateFormat _apiDateFormat = DateFormat('yyyy.MM.dd');

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _startDate = null;
      _endDate = null;
      _sortBy = 'Tarih';
      _isAscending = true;
    });
    BlocProvider.of<AlinanFaturalarBloc>(context).add(LoadAlinanFaturalar(
        prefix: 'yourTablePrefix', suffix: 'yourTableSuffix'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 55, 69, 10),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        title: Text(
          'Alış Faturaları',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          DropdownButton<String>(
            value: _sortBy,
            dropdownColor: Color.fromRGBO(35, 55, 69, 10),
            style: TextStyle(color: Colors.white),
            underline: Container(),
            icon: Icon(Icons.sort, color: Colors.white),
            items: <String>['Tarih', 'Tutar'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _sortBy = newValue!;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
              });
            },
          ),
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
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Color.fromRGBO(65, 190, 184, 1),
                          ),
                          foregroundColor:
                              WidgetStatePropertyAll<Color>(Colors.white),
                          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            locale: Locale('tr'),
                          );
                          if (selectedDate != null &&
                              selectedDate != _startDate) {
                            setState(() {
                              _startDate = selectedDate;
                            });
                          }
                        },
                        child: Text(
                          _startDate != null
                              ? _displayDateFormat.format(_startDate!)
                              : 'Başlangıç Tarihi',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Color.fromRGBO(65, 190, 184, 1),
                          ),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            locale: Locale('tr'),
                          );
                          if (selectedDate != null &&
                              selectedDate != _endDate) {
                            setState(() {
                              _endDate = selectedDate;
                            });
                          }
                        },
                        child: Text(
                          _endDate != null
                              ? _displayDateFormat.format(_endDate!)
                              : 'Bitiş Tarihi',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => AlinanFaturalarBloc(ApiHandler())
          ..add(LoadAlinanFaturalar(
              prefix: 'yourTablePrefix', suffix: 'yourTableSuffix')),
        child: BlocBuilder<AlinanFaturalarBloc, AlinanFaturalarState>(
          builder: (context, state) {
            if (state is AlinanFaturalarInitial) {
              return Center(child: Text('Listelenecek kayıt yok'));
            } else if (state is AlinanFaturaLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AlinanFaturalarLoadSuccess) {
              final filteredCariHesaplar = state.Faturalar.where((cariHesap) {
                final definition = cariHesap.definition?.toLowerCase() ?? '';
                final trCode = cariHesap.trCode?.toLowerCase() ?? '';

                DateTime? date;
                if (cariHesap.date != null) {
                  try {
                    date = _apiDateFormat.parse(cariHesap.date!);
                  } catch (e) {
                    print('Date parsing error: $e');
                  }
                }

                final isDateInRange = (_startDate == null ||
                        (date != null &&
                            date.isAfter(
                                _startDate!.subtract(Duration(days: 1))))) &&
                    (_endDate == null ||
                        (date != null &&
                            date.isBefore(_endDate!.add(Duration(days: 1)))));

                return (definition.contains(_searchQuery) ||
                        trCode.contains(_searchQuery)) &&
                    isDateInRange;
              }).toList();
              filteredCariHesaplar.sort((a, b) {
                int comparisonResult;

                if (_sortBy == 'Tarih') {
                  DateTime dateA = _apiDateFormat.parse(a.date!);
                  DateTime dateB = _apiDateFormat.parse(b.date!);
                  comparisonResult = dateB.compareTo(dateA);
                } else if (_sortBy == 'Tutar') {
                  comparisonResult = a.netTotal!.compareTo(b.netTotal!);
                } else {
                  comparisonResult = 0;
                }

                if (comparisonResult == 0) {
                  comparisonResult =
                      (a.definition ?? '').compareTo(b.definition ?? '');
                }

                return _isAscending ? comparisonResult : -comparisonResult;
              });

              return ListView.builder(
                itemCount: filteredCariHesaplar.length,
                itemBuilder: (context, index) {
                  final cariHesap = filteredCariHesaplar[index];

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color.fromRGBO(45, 65, 80, 50),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return FaturaDetayDialog(
                                  tur: cariHesap.TrCodeNum,
                                  logicalRef: cariHesap.logicalRef,
                                );
                              },
                            );
                          },
                          title: Text(
                            cariHesap.definition ?? '',
                            style: TextStyle(
                                color: Color.fromRGBO(85, 185, 180, 20),
                                fontSize: 19),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${cariHesap.trCode}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text(
                                _displayDateFormat.format(
                                    _apiDateFormat.parse(cariHesap.date!)),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${formatter1.format(cariHesap.netTotal)} TL',
                                style: TextStyle(
                                    color: Color.fromRGBO(85, 185, 180, 20),
                                    fontSize: 19),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ));
                },
              );
            } else if (state is AlinanFaturaLoadFailure) {
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