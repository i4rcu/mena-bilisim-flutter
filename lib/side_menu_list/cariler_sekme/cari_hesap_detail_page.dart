import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart'; // Add this for date formatting

class CariHesapDetailPage extends StatefulWidget {
  final int logicalref;

  CariHesapDetailPage({required this.logicalref});

  @override
  _CariHesapDetailPageState createState() => _CariHesapDetailPageState();
}

class _CariHesapDetailPageState extends State<CariHesapDetailPage> {
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
    return  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(34, 54, 69, 20),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(34, 54, 69, 20),
          title: Text(
            'Cari Hesap Detayları',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
  icon: Icon(Icons.file_download, color: Colors.white),
  onPressed: () {
    final state = context.read<CariHesapBloc>().state;
    if (state is CariHesapDetailesLoaded) {
      _exportToExcelWithStyles(state.cariHesapDetails);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler yüklenmedi.')),
      );
    }
  },
),
          ],
        ),
        body: BlocProvider(
          create: (context) => CariHesapBloc(ApiHandler())
            ..add(FetchCariHesapDetails("", "", widget.logicalref)),
          child: BlocListener<CariHesapBloc, CariHesapState>(
            listener: (context, state) {
              if (state is CariHesapDetailesLoaded) {
                if (_filterOptions.isEmpty) {
                  setState(() {
                    _filterOptions = state.cariHesapDetails
                        .map((detail) => detail.trCode ?? 'Unknown')
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
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          icon: Icon(Icons.clear,color: Colors.white,),
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
                  child: BlocBuilder<CariHesapBloc, CariHesapState>(
                    builder: (context, state) {
                      if (state is CariHesapLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is CariHesapDetailesLoaded) {
                        final filteredCariHesapDetails = state.cariHesapDetails
                            .where((detail) =>
                                detail.trCode
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ??
                                false)
                            .where((detail) =>
                                _selectedFilter == 'Hepsi' ||
                                detail.trCode == _selectedFilter)
                            .where((detail) {
                          final detailDate = detail.date != null
                              ? _dateFormat.parse(detail.date!) // Updated parsing
                              : null;
                          if (_startDate != null && _endDate != null) {
                            return detailDate != null &&
                                detailDate.isAfter(
                                    _startDate!.subtract(Duration(days: 1))) &&
                                detailDate
                                    .isBefore(_endDate!.add(Duration(days: 1)));
                          }
                          return true;
                        }).toList();
      
                        filteredCariHesapDetails.sort((a, b) {
                          final amountA = a.amount ?? 0;
                          final amountB = b.amount ?? 0;
      
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
                            final cariHesap = filteredCariHesapDetails[index];
                            return ListTile(
                              title: Text(
                                '${cariHesap.trCode}',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tarih: ${cariHesap.date}',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                cariHesap.amount.toString(),
                                style:
                                    TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              onTap: () async {
                                if (cariHesap.trCode != "Nakit Tahsilat" &&
                                    cariHesap.trCode != "Nakit Ödeme") {
                                  _showIslemPopup(context,
                                      trcode: cariHesap.trCode,
                                      invoice: cariHesap.invoiceRef,
                                      tranno: cariHesap.tranNo,
                                      logicalref: widget.logicalref);
                                }
                              },
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
              ],
            ),
          ),
        ),
      ),
    ));
  }
  void _exportToExcelWithStyles(List<CariHesapDetail> faturalar) async {
  var excel = Excel.createExcel();

  // Rename the default sheet
  String defaultSheet = excel.getDefaultSheet()!;
  excel.rename(defaultSheet, 'Cari Hesap Detayi');

  Sheet? sheetObject = excel['Cari Hesap Detayi'];

  // Define a custom style for headers
  CellStyle headerStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Calibri),
    bold: true,
    underline: Underline.Double,
    textWrapping: TextWrapping.WrapText
  );
  CellStyle cellStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Calibri),
    underline: Underline.None,
    textWrapping: TextWrapping.WrapText
  );

  // Add headers
   sheetObject.appendRow([
    TextCellValue( 'İşlem'),
    TextCellValue('Tarih' ),
    TextCellValue('Tutar (TL)' ),
  ]);


  // Apply styles to the header row (row 0, since indexing starts at 0)
  for (int col = 0; col < 4; col++) {
    var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
    cell.cellStyle = headerStyle;
  }

  // Add data rows
  for (var fatura in faturalar) {
    sheetObject.appendRow([
      TextCellValue( fatura.clientDefinition!),
      TextCellValue( fatura.date!),
      DoubleCellValue( fatura.trNet!),
      
    ]);
  }
  for (int col = 0; col < 4; col++) {
    for(int row = 1 ; row < faturalar.length +1;row++){
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex:row ));
    cell.cellStyle = cellStyle;
    }
    
  }

  // Save the file
  var directory = await getTemporaryDirectory();
  var filePath = '${directory.path}/CariHesap_detay.xlsx';

  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.encode()!);
   OpenFile.open(filePath);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Excel dosyası oluşturuldu: $filePath'),
      action: SnackBarAction(
        label: 'Aç',
        onPressed: () {
         
        },
      ),
    ),
  );
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

void _showIslemPopup(
  BuildContext context, {
  required String? trcode,
  required int? invoice,
  required String? tranno,
  required int? logicalref,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => CariHesapBloc(ApiHandler())
          ..add(fetchCariHesapProcessDetails(
              "", "", trcode, invoice, tranno, logicalref)),
        child: BlocListener<CariHesapBloc, CariHesapState>(
          listener: (context, state) {
            if (state is CariHesapError) {
              // Handle error state here if needed
            }
          },
          child: AlertDialog(
            backgroundColor: Color.fromRGBO(36, 64, 72, 50),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(trcode ?? "Detail",style: TextStyle(color: Colors.white),), // Set trCode as the title
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: double
                  .maxFinite, // This makes the dialog take the width it needs
              child: BlocBuilder<CariHesapBloc, CariHesapState>(
                builder: (context, state) {
                  if (state is CariHesapDetailLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CariHesapVirmanFisiDetailesLoaded) {
                    if (state.virmanFisiDetails.isEmpty) {
                      return Center(child: Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0, 
                      child: ListView.builder(
                        shrinkWrap:
                            true, 
                        itemCount: state.virmanFisiDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.virmanFisiDetails[index];
                          return ListTile(
                            title: Text(
                              item.name!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                              ),
                            ),
                            trailing: Text(
                              item.amount.toString() + " TL",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CariHesapBorcDekontuDetailesLoaded) {
                    if (state.BorcDekontuDetails.isEmpty) {
                      return Center(child: Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.BorcDekontuDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.BorcDekontuDetails[index];
                          return ListTile(
                            title: Text(
                              item.name!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                              ),
                            ),
                            trailing: Text(
                              item.amount.toString() + " TL",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CariHesapNakitTahsilatDetailesLoaded) {
                    if (state.NakitTahsilatDetails.isEmpty) {
                      return Center(child: Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.NakitTahsilatDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.NakitTahsilatDetails[index];
                          return ListTile(
                            title: Text(
                                item.code.toString()), // Customize as needed
                          );
                        },
                      ),
                    );
                  } else if (state is CariHesapGelenHavaleDetailesLoaded) {
                    if (state.GelenHavaleDetails.isEmpty) {
                      return Center(child: Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.GelenHavaleDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.GelenHavaleDetails[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  item.banka!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              item.amount.toString() + " TL",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CariHesapAlinanHizmetDetailesLoaded) {
                    if (state.HizmetFaturasiDetails.isEmpty) {
                      return Center(child:Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.HizmetFaturasiDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.HizmetFaturasiDetails[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  item.code!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              item.total.toString() + " TL",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CariHesapCekVeSenetDetailesLoaded) {
                    if (state.CekVeSenetDetails.isEmpty) {
                      return Center(child: Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.CekVeSenetDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.CekVeSenetDetails[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              item.total.toString() + " TL",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CariHesapKrediKartDetailesLoaded) {
                    if (state.KrediKartiDetails.isEmpty) {
                      return Center(child: Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.KrediKartiDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.KrediKartiDetails[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  item.code!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              item.amount.toString() + " TL",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CariHesapDefaultDetailesLoaded) {
                    if (state.DefaultCaseDetails.isEmpty) {
                      return Center(child: Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),));
                    }
                    return SizedBox(
                      height: 300.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.DefaultCaseDetails.length,
                        itemBuilder: (context, index) {
                          var item = state.DefaultCaseDetails[index];
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  item.amount!.toString() +
                                      " Adet * " +
                                      item.price.toString() +
                                      " TL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              item.total.toString() + " TL",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text("Gösterilecek bilgi bulunmamaktadır." ,
                      style: TextStyle(color: Colors.white),);
                  }
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}
  