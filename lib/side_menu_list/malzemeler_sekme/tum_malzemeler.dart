import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
    return  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child: Scaffold(
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
             BlocBuilder<MalzemelerBloc, MalzemelerState>(
    builder: (context, state) {
      bool isLoaded = state is TumMalzemeloaded;

      return IconButton(
        icon: Icon(Icons.file_download, color: Colors.white),
        onPressed: isLoaded
            ? () {
                  print(state.TUMMALZEMELERR.length.toString());
                  _exportToExcelWithStyles(state.TUMMALZEMELERR);
                
              }
            : null, // Disable the button
      );
    },
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
                            filled: true,
        fillColor: Color.fromRGBO(56, 74, 82, 1),
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(68, 192, 186, 10),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(65, 190, 184, 20),
                                width: 2.0,
                              ),
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
                          contentPadding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
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
      ),
    ));
  }
    void _exportToExcelWithStyles(List<TumMalzemeler> faturalar) async {
  var excel = Excel.createExcel();

  // Rename the default sheet
  String defaultSheet = excel.getDefaultSheet()!;
  excel.rename(defaultSheet, 'Tüm Malzemeler');

  Sheet? sheetObject = excel['Tüm Malzemeler'];

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
    TextCellValue( 'Malzeme Adı'),
    TextCellValue( 'Malzeme Kodu'),
    TextCellValue('Stokta Kalan' ),
    
  ]);


  // Apply styles to the header row (row 0, since indexing starts at 0)
  for (int col = 0; col < 4; col++) {
    var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
    cell.cellStyle = headerStyle;
  }

  // Add data rows
  for (var fatura in faturalar) {
    sheetObject.appendRow([
      TextCellValue( fatura.name!),
      TextCellValue( fatura.code!),
      IntCellValue( fatura.elde!),
      
      
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
  var filePath = '${directory.path}/Tum_Malzemeler.xlsx';

  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.encode()!);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Excel dosyası oluşturuldu: $filePath'),
      action: SnackBarAction(
        label: 'Aç',
        onPressed: () {
          OpenFile.open(filePath);
        },
      ),
    ),
  );
}
}
