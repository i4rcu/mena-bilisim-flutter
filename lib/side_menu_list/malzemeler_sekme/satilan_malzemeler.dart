import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SatilanMalzemePage extends StatefulWidget {
  @override
  _SatilanMalzemePageState createState() => _SatilanMalzemePageState();
}

class _SatilanMalzemePageState extends State<SatilanMalzemePage> {
  late MalzemelerBloc _MalzemeBloc;
  String _searchQuery = '';
  bool _isAscending = true; // Sorting order for satır net tutar

  @override
  void initState() {
    super.initState();
    _MalzemeBloc = MalzemelerBloc(ApiHandler());
    _MalzemeBloc.add(FetchSatilanMalzeme());
  }



  @override
  void dispose() {
    _MalzemeBloc.close();
    super.dispose();
  }
  late List<HangiMalzemeKimeSatildi> filteredAndSortedCekler;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _MalzemeBloc,
      child:  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: Text('Hangi Malzeme Kime Satıldı'),
            backgroundColor: Color.fromRGBO(36, 64, 72, 1),
            actions: [
  BlocBuilder<MalzemelerBloc, MalzemelerState>(
    builder: (context, state) {
      bool isLoaded = state is Satilanmalzemeloaded;

      return IconButton(
        icon: Icon(Icons.file_download, color: Colors.white),
        onPressed: isLoaded
            ? () {
                  print(filteredAndSortedCekler.length.toString());
                  _exportToExcelWithStyles(filteredAndSortedCekler);
                
              }
            : null, // Disable the button
      );
    },
  ),
],

            
          ),
          backgroundColor: Color.fromRGBO(36, 64, 72, 1),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 10),
                Expanded(child: _buildDataTable()),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Stok veya Cari hesap adına göre ara',
        hintStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Color.fromRGBO(56, 74, 82, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

 Widget _buildDataTable() {
  return BlocBuilder<MalzemelerBloc, MalzemelerState>(
    builder: (context, state) {
      if (state is SatilanmlazemeLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is Satilanmalzemeloaded) {
         filteredAndSortedCekler = _sortCekler(_filterCekler(state.SATILANMALZEMELER));

        if (filteredAndSortedCekler.isEmpty) {
          return Center(
            child: Text(
              'Veri bulunamadı.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(56, 74, 82, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 300, // Set the fixed height of the table
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 1200, // Set minimum width for horizontal scroll
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Vertical scrolling
                    child: DataTable(
                      headingRowColor:
                          WidgetStateColor.resolveWith((states) => Colors.teal),
                      dataRowColor: WidgetStateColor.resolveWith(
                          (states) => Color.fromRGBO(56, 74, 82, 1)),
                      columns: _buildDataColumns(),
                      rows: _buildDataRows(filteredAndSortedCekler),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      } else if (state is SatilanmalzemeError) {
        return Center(
          child: Text(
            'Hata: ${state.message}',
            style: TextStyle(color: Colors.redAccent, fontSize: 18),
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}




  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(
        label: Text('Stok Adı', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Cari Hesap', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Satış Elemanı', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Miktar', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Birim Fiyat', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Satır Fiyat', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('KDV', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Row(
          children: [
            Text('Satır Net Tutar', style: TextStyle(color: Colors.white)),
            IconButton(
              icon: Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
                size: 16,
              ),
              onPressed: _toggleSort,
            ),
          ],
        ),
        numeric: true,
      ),
    ];
  }

  List<DataRow> _buildDataRows(List<HangiMalzemeKimeSatildi> cekler) {
    return cekler.map((cek) {
      return DataRow(
        cells: [
          DataCell(Text(cek.stoKADI ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.carIHESAP ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.satiSELEMANI ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.miktar?.toString() ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.bFIYAT?.toStringAsFixed(2) ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.satiRTUTARI?.toStringAsFixed(2) ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.kdv?.toStringAsFixed(2) ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.satiRNETTUTARI?.toStringAsFixed(2) ?? '', style: TextStyle(color: Colors.white))),
        ],
      );
    }).toList();
  }

  List<HangiMalzemeKimeSatildi> _filterCekler(List<HangiMalzemeKimeSatildi> cekler) {
    return cekler.where((cek) {
      final matchStokAdi = cek.stoKADI?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      final matchCariHesap = cek.carIHESAP?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;

      return matchStokAdi || matchCariHesap;
    }).toList();
  }

  List<HangiMalzemeKimeSatildi> _sortCekler(List<HangiMalzemeKimeSatildi> cekler) {
    cekler.sort((a, b) {
      final aNetTutar = a.satiRNETTUTARI ?? 0;
      final bNetTutar = b.satiRNETTUTARI ?? 0;
      return _isAscending ? aNetTutar.compareTo(bNetTutar) : bNetTutar.compareTo(aNetTutar);
    });
    return cekler;
  }

  void _toggleSort() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }
    void _exportToExcelWithStyles(List<HangiMalzemeKimeSatildi> faturalar) async {
  var excel = Excel.createExcel();

  // Rename the default sheet
  String defaultSheet = excel.getDefaultSheet()!;
  excel.rename(defaultSheet, 'Hangi Malzeme Kime Satıldı');

  Sheet? sheetObject = excel['Hangi Malzeme Kime Satıldı'];

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
    TextCellValue( 'Cari Hesap'),
    TextCellValue('Satış Elemanı' ),
    TextCellValue('Miktar' ),
    TextCellValue('Birim Fiyat' ),
    TextCellValue('Satır Fİyat' ),
    TextCellValue('KDV' ),
    TextCellValue('Satır Net Tutar' ),

  ]);


  // Apply styles to the header row (row 0, since indexing starts at 0)
  for (int col = 0; col < 4; col++) {
    var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
    cell.cellStyle = headerStyle;
  }

  // Add data rows
  for (var fatura in faturalar) {
    sheetObject.appendRow([
      TextCellValue( fatura.stoKKODU!),
      TextCellValue( fatura.carIHESAP!),
      TextCellValue( fatura.satiSELEMANI ?? ""),
      DoubleCellValue( fatura.miktar!),
      DoubleCellValue( fatura.bFIYAT!),
      DoubleCellValue( fatura.satiRTUTARI!),
      DoubleCellValue( fatura.kdv!),
      DoubleCellValue( fatura.satiRNETTUTARI!),
      
      
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
  var filePath = '${directory.path}/Hangi_Malzeme_Kime_Satildi.xlsx';

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
