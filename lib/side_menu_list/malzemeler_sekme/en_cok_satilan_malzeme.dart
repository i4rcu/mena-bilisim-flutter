import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
class EnCokSatilanMalzemeListPage extends StatefulWidget {
  @override
  _EnCokSatilanMalzemeListPageState createState() =>
      _EnCokSatilanMalzemeListPageState();
}
class _EnCokSatilanMalzemeListPageState extends State<EnCokSatilanMalzemeListPage> {
  String _searchQuery = '';
  DateTime _selectedDate =DateTime(DateTime.now().year, 1, 1); // Initialize later
  int daysDifference = 0;
 late List<EnCokSatilanMalzeme> filteredCariHesaplar;
  @override
  void initState() {
    super.initState();
    // Set the default value to January 1 of the current year
    _selectedDate = DateTime(DateTime.now().year, 1, 1);
    daysDifference = DateTime.now().difference(_selectedDate).inDays; // Calculate initial days difference
    // Fetch the initial data
    BlocProvider.of<MalzemelerBloc>(context).add(
      fetchEnCokSatilanMalzemeler("tablePrefix", "tableSuffix", daysDifference.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child:Scaffold(
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(35, 55, 69, 10),
          title: Text(
            'En Çok Satılan Malzemeler',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            IconButton(
  icon: Icon(Icons.file_download, color: Colors.white),
  onPressed: () {
    final state = context.read<MalzemelerBloc>().state;
    if (state is EnCokSatilanMalzemeLoaded) {
      _exportToExcelWithStyles(filteredCariHesaplar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler yüklenmedi.')),
      );
    }
  },
),
          ],
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
                      labelText: 'Ara',
                      filled: true,
        fillColor: Color.fromRGBO(56, 74, 82, 1),
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(68, 192, 186, 10)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(68, 192, 186, 10), width: 2.0),
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
                            initialDate: _selectedDate,
                                                      locale: Locale('tr','TR'),
      
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            helpText: 'Tarih Seç',
                          );
                          if (pickedDate != null && pickedDate != _selectedDate) {
                            setState(() {
                              _selectedDate = pickedDate;
                              daysDifference = DateTime.now().difference(_selectedDate).inDays; // Recalculate days difference
                            });
                            // Trigger the Bloc event with the new daysDifference
                            BlocProvider.of<MalzemelerBloc>(context).add(
                              fetchEnCokSatilanMalzemeler("tablePrefix", "tableSuffix", daysDifference.toString()),
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
        body: BlocBuilder<MalzemelerBloc, MalzemelerState>(
          builder: (context, state) {
            if (state is MalzemelerInitial) {
              return Center(child: Text('Listelenecek kayıt yok'));
            } else if (state is EnCokSatilanMalzemeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EnCokSatilanMalzemeLoaded) {
      
              if (_searchQuery.isEmpty) {
                filteredCariHesaplar = state.EnCokSatilanMalzemeler;
              } else {
                filteredCariHesaplar = state.EnCokSatilanMalzemeler.where((cariHesap) {
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
                      contentPadding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
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
                          color: isNegative ? Color.fromARGB(255, 255, 20, 3) : Color.fromRGBO(47, 175, 107, 20),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      
                    ),
                  );
                },
              );
            } else if (state is EnCokSatilanMalzemeError ) {
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
    ));
  }
    void _exportToExcelWithStyles(List<EnCokSatilanMalzeme> faturalar) async {
  var excel = Excel.createExcel();

  // Rename the default sheet
  String defaultSheet = excel.getDefaultSheet()!;
  excel.rename(defaultSheet, 'En Çok Satılan Malzemeler');

  Sheet? sheetObject = excel['En Çok Satılan Malzemeler'];

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
      TextCellValue( fatura.name!),
      DoubleCellValue( fatura.tutar!),
      
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
  var filePath = '${directory.path}/En_Cok_Satilan_Malzemeler.xlsx';

  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.encode()!);

   OpenFile.open(filePath);
}
}
