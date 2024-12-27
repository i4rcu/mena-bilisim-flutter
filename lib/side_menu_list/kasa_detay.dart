import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bloc/kasalar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class KasaDetayPage extends StatefulWidget {
  final int logicalref;

  KasaDetayPage({required this.logicalref});

  @override
  _KasaDetayPageState createState() => _KasaDetayPageState();
}

class _KasaDetayPageState extends State<KasaDetayPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Hepsi';
  bool _isAscending = true;
  List<String> _filterOptions = [];
  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat _dateFormat =
      DateFormat('yyyy.MM.dd'); // Updated date format

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) {
        return Localizations(
          locale: const Locale('tr', 'TR'), // Turkish locale
          delegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: AlertDialog(
            content: DateRangePickerDialog(
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              initialDateRange: _startDate != null && _endDate != null
                  ? DateTimeRange(start: _startDate!, end: _endDate!)
                  : null,
            ),
          ),
        );
      },
    );

    if (picked != null &&
        picked.start != _startDate &&
        picked.end != _endDate) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaler:
                TextScaler.linear(0.9)), // Force text scale factor to 1.0
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromRGBO(34, 54, 69, 20),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color.fromRGBO(34, 54, 69, 20),
              title: Text(
                'Kasa Detayları',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                
              ],
            ),
            body: BlocProvider(
              create: (context) => kasalarBloc(ApiHandler())
                ..add(Fetchkasadetaylari(widget.logicalref)),
              child: BlocListener<kasalarBloc, kasalarState>(
                listener: (context, state) {
                  if (state is kasadetayLoaded) {
                    if (_filterOptions.isEmpty) {
                      setState(() {
                        _filterOptions = state.kasadetaylar
                            .map((detail) => detail.islem ?? 'Bilinmeyen')
                            .toSet()
                            .toList();
                        _filterOptions.sort();
                      });
                    }
                  }
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(56, 74, 82, 1),
                                labelText: 'Ara (İşlem)',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(68, 192, 186, 10),
                                    width: 2.0, // Border width when focused
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                suffixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          DropdownButton<String>(
                            dropdownColor: Color.fromRGBO(34, 54, 69, 20),
                            value: _selectedFilter,
                            style: TextStyle(color: Colors.white),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedFilter = newValue ?? 'Hepsi';
                              });
                            },
                            items: _filterOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                              ..insert(
                                  0,
                                  DropdownMenuItem<String>(
                                      value: 'Hepsi', child: Text('Hepsi'))),
                            hint: Text('Filtre'),
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            icon: Icon(
                              _isAscending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isAscending = !_isAscending;
                              });
                            },
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                            onPressed: () => _selectDateRange(context),
                          ),
                        ],
                      ),
                    ),
                    if (_startDate != null && _endDate != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Tarih Aralığı: ${_dateFormat.format(_startDate!)} - ${_dateFormat.format(_endDate!)}',
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _startDate = null;
                                  _endDate = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: BlocBuilder<kasalarBloc, kasalarState>(
                        builder: (context, state) {
                          if (state is kasadetayLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is kasadetayLoaded) {
                            final filteredCariHesapDetails = state
                                .kasadetaylar
                                .where((detail) =>
                                    detail.islem
                                        ?.toLowerCase()
                                        .contains(_searchQuery) ??
                                    false)
                                .where((detail) =>
                                    _selectedFilter == 'Hepsi' ||
                                    detail.islem == _selectedFilter)
                                .where((detail) {
                              final detailDate = detail.tarih != null
                                  ? _dateFormat
                                      .parse(detail.tarih!) // Updated parsing
                                  : null;
                              if (_startDate != null && _endDate != null) {
                                return detailDate != null &&
                                    detailDate.isAfter(_startDate!
                                        .subtract(Duration(days: 1))) &&
                                    detailDate.isBefore(
                                        _endDate!.add(Duration(days: 1)));
                              }
                              return true;
                            }).toList();

                            filteredCariHesapDetails.sort((a, b) {
                              final amountA = a.tutar ?? 0;
                              final amountB = b.tutar ?? 0;

                              if (_isAscending) {
                                return amountA.compareTo(amountB);
                              } else {
                                return amountB.compareTo(amountA);
                              }
                            });

                            return ListView.builder(
                              padding: EdgeInsets.all(16.0),
                              itemCount: filteredCariHesapDetails.length,
                              itemBuilder: (context, index) {
                                final cariHesap =
                                    filteredCariHesapDetails[index];
                                return ListTile(
                                  leading: Text(
                                    '${cariHesap.cariHesap}',
                                    style: TextStyle(color: Colors.white,fontSize: 16),
                                  ),
                                  title: Text(
                                    '${cariHesap.islem}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tarih: ${cariHesap.tarih}',
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    cariHesap.tutar.toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  onTap: () async {
                                    
                                  },
                                );
                              },
                            );
                          } else if (state is kasadetayError) {
                            return Center(
                                child: Text('Error: ${state.message}'));
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
