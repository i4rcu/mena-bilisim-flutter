import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bankalar_bloc/bankalar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class BankalarListPage extends StatefulWidget {
  @override
  _BankalarListPageState createState() => _BankalarListPageState();
}

class _BankalarListPageState extends State<BankalarListPage> {
  String _searchQuery = '';
  final formatter1 =
            NumberFormat('#,##0.00', 'tr_TR'); 
            late List<Banka> filteredCariHesaplar;
            



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BankalarBloc>(context).add(
      FetchBankalar());
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
            'Bankalar',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            BlocBuilder<BankalarBloc, BankalarState>(
    builder: (context, state) {
      bool isLoaded = state is BankalarLoaded;

      return IconButton(
        icon: Icon(Icons.file_download, color: Colors.white),
        onPressed: isLoaded
            ? () {
                  print(filteredCariHesaplar.length.toString());
                  _exportToExcelWithStyles(filteredCariHesaplar);
                
              }
            : (){print("ssssssssssssssssssssssssssssssssssssssssssssssssssssss");}, // Disable the button
      );
    },
  ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
                      color: Color.fromRGBO(68, 192, 186, 10), // Border color when focused
                      width: 2.0, // Border width when focused
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
          ),
        ),
        body: BlocProvider(
          create: (context) => BankalarBloc(ApiHandler())..add(FetchBankalar()),
          child: BlocBuilder<BankalarBloc, BankalarState>(
            builder: (context, state) {
              if (state is BankalarInitial) {
                return Center(child: Text('Listelenecek kayıt yok'));
              } else if (state is BankalarLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is BankalarLoaded) {
                 filteredCariHesaplar = state.Bankalar.where((cariHesap) {
                  return cariHesap.hesap!.toLowerCase().contains(_searchQuery) ||
                      cariHesap.banka!.toLowerCase().contains(_searchQuery);
                }).toList();
      
                return ListView.builder(
                  itemCount: filteredCariHesaplar.length,
                  itemBuilder: (context, index) {
                    final cariHesap = filteredCariHesaplar[index];
                    final isNegative = cariHesap.bakiye! < 0;
                    return Card(
                      color: Color.fromRGBO(45, 65, 80, 50),
                      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cariHesap.hesap!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            Text(
                              cariHesap.banka!,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${ formatter1.format(cariHesap.bakiye!) } ${isNegative ? "(A)" : "(B)"}',
                          style: TextStyle(
                            color: isNegative
                                ? Color.fromARGB(255, 255, 20, 3)
                                : Color.fromRGBO(47, 175, 107, 20),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is BankalarError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return Container();
            },
          ),
        ),
      ),
    ));
  }
    void _exportToExcelWithStyles(List<Banka> faturalar) async {
  var excel = Excel.createExcel();

  // Rename the default sheet
  String defaultSheet = excel.getDefaultSheet()!;
  excel.rename(defaultSheet, 'Bankalar');

  Sheet? sheetObject = excel['Bankalar'];

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
    TextCellValue( 'Banka Adı'),
    TextCellValue( 'Şubesi'),
    TextCellValue('Bakiye (TL)' ),
  ]);


  // Apply styles to the header row (row 0, since indexing starts at 0)
  for (int col = 0; col < 4; col++) {
    var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
    cell.cellStyle = headerStyle;
  }

  // Add data rows
  for (var fatura in faturalar) {
    sheetObject.appendRow([
      TextCellValue( fatura.banka!),
      TextCellValue( fatura.hesap!),
      TextCellValue( fatura.banka!.toString()),
      
      
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
  var filePath = '${directory.path}/Bankalar.xlsx';

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
