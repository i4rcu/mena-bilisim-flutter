import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AllItemsPage extends StatefulWidget {
  @override
  _AllItemsPageState createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  String searchQuery = '';
  late List<HMalzeme> allItems; // Original list of items
  late List<HMalzeme> filteredItems; // Filtered list of items

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MalzemelerBloc>(context).add(FetchHmalzeme());
    allItems = []; // Initialize the lists
    filteredItems = [];
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredItems = allItems.where((item) {
        final name = item.name?.toLowerCase() ?? '';
        final code = item.code?.toLowerCase() ?? '';
        return name.contains(searchQuery) || code.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(35, 55, 69, 10),
          title: Text('Hareket Görmeyen Malzemeler', style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
  icon: Icon(Icons.file_download, color: Colors.white),
  onPressed: () {
    final state = context.read<MalzemelerBloc>().state;
    if (state is Hmalzemeloaded) {
      _exportToExcelWithStyles(state.HMALZEMELER);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler yüklenmedi.')),
      );
    }
  },
),
          ],
        ),
        body: BlocBuilder<MalzemelerBloc, MalzemelerState>(
          builder: (context, state) {
            if (state is HmlazemeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is Hmalzemeloaded) {
              allItems = state.HMALZEMELER; // Store original list
              filteredItems = searchQuery.isEmpty
                  ? allItems
                  : allItems.where((item) {
                      final name = item.name?.toLowerCase() ?? '';
                      final code = item.code?.toLowerCase() ?? '';
                      return name.contains(searchQuery) || code.contains(searchQuery);
                    }).toList();

              return Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                            color: Color.fromRGBO(68, 192, 186, 10),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                      onChanged: (query) {
                        updateSearchQuery(query);
                      },
                    ),
                  ),
                  // Display filtered items
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Color.fromRGBO(45, 65, 80, 50),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? '',
                                    style: TextStyle(
                                      color: Color.fromRGBO(85, 185, 180, 20),
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    item.code ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is HmalzemeError) {
              return Center(child: Text('Veri Yüklenemedi: ${state.message}'));
            } else {
              return Center(child: Text('Beklenmedik bir hata oluştu'));
            }
          },
        ),
      ),
    ));
  }
    void _exportToExcelWithStyles(List<HMalzeme> faturalar) async {
  var excel = Excel.createExcel();

  // Rename the default sheet
  String defaultSheet = excel.getDefaultSheet()!;
  excel.rename(defaultSheet, 'Hareket Görmeyen Malzemeler');

  Sheet? sheetObject = excel['Hareket Görmeyen Malzemeler'];

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
  var filePath = '${directory.path}/Hareket_Gormeyen_Malzemeler.xlsx';

  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.encode()!);

   OpenFile.open(filePath);
}
}
