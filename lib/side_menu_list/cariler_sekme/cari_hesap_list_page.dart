import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class CariHesapListPage extends StatefulWidget {
  @override
  _CariHesapListPageState createState() => _CariHesapListPageState();
}

class _CariHesapListPageState extends State<CariHesapListPage> {
  String _searchQuery = '';
  void _resetFilters() {
    BlocProvider.of<CariHesapBloc>(context).add(
      FetchCariHesaplar('yourTablePrefix', 'yourTableSuffix'),
    );
  }

  late List<CariHesap> filteredCariHesaplar;
  @override
  void initState() {
    super.initState();
    _resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaler:
                TextScaler.linear(0.9)), // Force text scale factor to 1.0
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromRGBO(35, 55, 69, 10),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color.fromRGBO(35, 55, 69, 10),
              title: Text(
                'Müşteriler',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.file_download, color: Colors.white),
                  onPressed: () {
                    final state = context.read<CariHesapBloc>().state;
                    if (state is CariHesapLoaded) {
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
                preferredSize: Size.fromHeight(70),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(56, 74, 82, 1),
                        labelText: 'Ara',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
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
                    filteredCariHesaplar =
                        state.cariHesaplar.where((cariHesap) {
                      return cariHesap.name
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          cariHesap.code.toLowerCase().contains(_searchQuery);
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredCariHesaplar.length,
                      itemBuilder: (context, index) {
                        final cariHesap = filteredCariHesaplar[index];
                        final isNegative = cariHesap.bakiye < 0;
                        return Card(
                            color: Color.fromRGBO(45, 65, 80, 50),
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
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
                                    cariHesap.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    cariHesap.code,
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 15),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${cariHesap.bakiye.toStringAsFixed(2)} ${isNegative ? "(A)" : "(B)"}',
                                    style: TextStyle(
                                      color: isNegative
                                          ? Color.fromARGB(255, 255, 20, 3)
                                          : Color.fromRGBO(47, 175, 107, 20),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.share, color: Colors.white),
                                    onPressed: () {
                                      // Dispatch event to fetch details
                                      context.read<CariHesapBloc>().add(
                                          FetchCariHesapDetails(
                                              "", "", cariHesap.logicalRef));

                                      // Listen for state changes
                                      context
                                          .read<CariHesapBloc>()
                                          .stream
                                          .listen((state) {
                                        if (state is CariHesapDetailesLoaded) {
                                          // Generate and 
                                          //
                                          // the PDF once details are loaded
                                          _generateAndSharePdf(cariHesap,
                                              state.cariHesapDetails);
                                        } else if (state is CariHesapError) {
                                          // Handle error state
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to fetch details: ${state.message}')),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CariHesapDetailPage(
                                        logicalref: cariHesap.logicalRef),
                                  ),
                                );
                              },
                            ));
                      },
                    );
                  } else if (state is CariHesapDetailesLoaded) {
                    filteredCariHesaplar =
                        state.cariHesaplar.where((cariHesap) {
                      return cariHesap.name
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          cariHesap.code.toLowerCase().contains(_searchQuery);
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredCariHesaplar.length,
                      itemBuilder: (context, index) {
                        final cariHesap = filteredCariHesaplar[index];
                        final isNegative = cariHesap.bakiye < 0;
                        return Card(
                            color: Color.fromRGBO(45, 65, 80, 50),
                            margin: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
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
                                    cariHesap.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    cariHesap.code,
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 15),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${cariHesap.bakiye.toStringAsFixed(2)} ${isNegative ? "(A)" : "(B)"}',
                                    style: TextStyle(
                                      color: isNegative
                                          ? Color.fromARGB(255, 255, 20, 3)
                                          : Color.fromRGBO(47, 175, 107, 20),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.share, color: Colors.white),
                                    onPressed: () {
                                      // Dispatch event to fetch details
                                      context.read<CariHesapBloc>().add(
                                          FetchCariHesapDetails(
                                              "", "", cariHesap.logicalRef));

                                      // Listen for state changes
                                      context
                                          .read<CariHesapBloc>()
                                          .stream
                                          .listen((state) {
                                        if (state is CariHesapDetailesLoaded) {
                                          // Generate and share the PDF once details are loaded
                                          _generateAndSharePdf(cariHesap,
                                              state.cariHesapDetails);
                                        } else if (state is CariHesapError) {
                                          // Handle error state
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to fetch details: ${state.message}')),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ],
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
                            ));
                      },
                    );
                  } else if (state is CariHesapError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Container();
                },
              ),
            ),
          ),
        ));
  }

  void _exportToExcelWithStyles(List<CariHesap> faturalar) async {
    var excel = Excel.createExcel();

    String defaultSheet = excel.getDefaultSheet()!;
    excel.rename(defaultSheet, 'Cari Hesaplar');

    Sheet? sheetObject = excel['Cari Hesaplar'];

    CellStyle headerStyle = CellStyle(
        fontFamily: getFontFamily(FontFamily.Calibri),
        bold: true,
        underline: Underline.Double,
        textWrapping: TextWrapping.WrapText);
    CellStyle cellStyle = CellStyle(
        fontFamily: getFontFamily(FontFamily.Calibri),
        underline: Underline.None,
        textWrapping: TextWrapping.WrapText);

    sheetObject.appendRow([
      TextCellValue('Cari Hesap'),
      TextCellValue('Kodu'),
      TextCellValue('Bakiyesi (TL)'),
    ]);

    for (int col = 0; col < 4; col++) {
      var cell = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.cellStyle = headerStyle;
    }

    // Add data rows
    for (var fatura in faturalar) {
      sheetObject.appendRow([
        TextCellValue(fatura.name),
        TextCellValue(fatura.code),
        DoubleCellValue(fatura.bakiye),
      ]);
    }
    for (int col = 0; col < 4; col++) {
      for (int row = 1; row < faturalar.length + 1; row++) {
        var cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
        cell.cellStyle = cellStyle;
      }
    }

    // Save the file
    var directory = await getTemporaryDirectory();
    var filePath = '${directory.path}/CariHesaplar.xlsx';

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);
    OpenFile.open(filePath);
  }

  void _generateAndSharePdf(
      CariHesap cariHesap, List<CariHesapDetail> details) async {
    final pdf = pw.Document();

    final fontData = await rootBundle
        .load('assets/fonts/NotoSans-VariableFont_wdth,wght.ttf');
    final ttf = pw.Font.ttf(fontData);

    final headerColor = PdfColor.fromHex('#4CAF50');
    final alternateRowColor = PdfColors.grey300;
    final textColor = PdfColor.fromHex('#212121');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Cari Hesap Ekstresi',
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: headerColor,
                      font: ttf)),
              pw.SizedBox(height: 16),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: headerColor, width: 2),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                padding: const pw.EdgeInsets.all(12),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Adı: ${cariHesap.name}',
                        style: pw.TextStyle(
                            fontSize: 16, color: textColor, font: ttf)),
                    pw.Text('Kodu: ${cariHesap.code}',
                        style: pw.TextStyle(
                            fontSize: 16, color: textColor, font: ttf)),
                    pw.Text('Bakiye: ${cariHesap.bakiye.toStringAsFixed(2)} TL',
                        style: pw.TextStyle(
                            fontSize: 16, color: textColor, font: ttf)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Detayları:',
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: headerColor,
                      font: ttf)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: headerColor),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: headerColor),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Tarih',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                                font: ttf)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('İşlem Türü',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                                font: ttf)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Tutar',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                                font: ttf)),
                      ),
                    ],
                  ),
                  ...details.asMap().entries.map((entry) {
                    final index = entry.key;
                    final detail = entry.value;
                    final isAlternate = index % 2 == 1;
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color:
                            isAlternate ? alternateRowColor : PdfColors.white,
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(detail.date!,
                              style: pw.TextStyle(color: textColor, font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(detail.trCode!,
                              style: pw.TextStyle(color: textColor, font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              '${detail.amount!.toStringAsFixed(2)} TL',
                              style: pw.TextStyle(color: textColor, font: ttf)),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/cari_hesap_detay.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Cari Hesap Detayları: ${cariHesap.name}',
    );
  }
}
