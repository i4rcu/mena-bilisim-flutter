import 'dart:io';

import 'package:excel/excel.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bloc/kasalar_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/kasa_detay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class KasalarListPage extends StatefulWidget {
  @override
  _KasalarListPageState createState() => _KasalarListPageState();
}

class _KasalarListPageState extends State<KasalarListPage> {
  String _searchQuery = '';
  final formatter1 = NumberFormat('#,##0.00', 'tr_TR');
  late List<KasaDto> filteredkasalar;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<kasalarBloc>(context).add(Fetchkasalar());
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
                'Kasalar',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                BlocBuilder<kasalarBloc, kasalarState>(
                  builder: (context, state) {
                    bool isLoaded = state is kasalarLoaded;

                    return IconButton(
                      icon: Icon(Icons.file_download, color: Colors.white),
                      onPressed: isLoaded
                          ? () {
                              _exportToExcelWithStyles(filteredkasalar);
                            }
                          : () {
                              ;
                            }, // Disable the button
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
                          color: Color.fromRGBO(
                              68, 192, 186, 10), // Border color when focused
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
              create: (context) =>
                  kasalarBloc(ApiHandler())..add(Fetchkasalar()),
              child: BlocBuilder<kasalarBloc, kasalarState>(
                builder: (context, state) {
                  if (state is kasalarInitial) {
                    return Center(child: Text('Listelenecek kayıt yok'));
                  } else if (state is kasalarLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is kasalarLoaded) {
                    filteredkasalar = state.kasalar.where((kasa) {
                      return kasa.name.toLowerCase().contains(_searchQuery) ||
                          kasa.code.toLowerCase().contains(_searchQuery);
                    }).toList();
                    return ListView.builder(
                      itemCount: filteredkasalar.length,
                      itemBuilder: (context, index) {
                        final kasa = filteredkasalar[index];
                        final isNegative = kasa.bakiye < 0;
                        return Card(
                          color: Color.fromRGBO(45, 65, 80, 50),
                          margin:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 15),
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
                                  kasa.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                Text(
                                  kasa.code,
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                                                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Text(
                                  '${formatter1.format(kasa.bakiye)} ${isNegative ? "(A)" : "(B)"}',
                                  style: TextStyle(
                                    color: isNegative
                                        ? Color.fromARGB(255, 255, 20, 3)
                                        : Color.fromRGBO(47, 175, 107, 20),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.share, color: Colors.white),
                                  onPressed: () {
                                    MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => kasalarBloc(ApiHandler()),
              child: KasalarListPage(),
            ),
          );
                                    // Dispatch event to fetch details
                                    context.read<kasalarBloc>().add(
                                        Fetchkasadetaylari(kasa.logicalRef));

                                    // Listen for state changes
                                    context
                                        .read<kasalarBloc>()
                                        .stream
                                        .listen((state) {
                                      if (state is kasadetayLoaded) {
                                         
                                        // Generate and share the PDF once details are loaded
                                        _generateAndSharePdf(
                                            kasa, state.kasadetaylar);
                                           
        
                                      } else if (state is kasadetayError) {
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KasaDetayPage(
                                      logicalref: kasa.logicalRef),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }else if (state is kasadetayLoaded){
                      filteredkasalar = state.kasa.where((kasa) {
                      return kasa.name.toLowerCase().contains(_searchQuery) ||
                          kasa.code.toLowerCase().contains(_searchQuery);
                    }).toList();
                    return ListView.builder(
                      itemCount: filteredkasalar.length,
                      itemBuilder: (context, index) {
                        final kasa = filteredkasalar[index];
                        final isNegative = kasa.bakiye < 0;
                        return Card(
                          color: Color.fromRGBO(45, 65, 80, 50),
                          margin:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 15),
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
                                  kasa.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                Text(
                                  kasa.code,
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                                                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Text(
                                  '${formatter1.format(kasa.bakiye)} ${isNegative ? "(A)" : "(B)"}',
                                  style: TextStyle(
                                    color: isNegative
                                        ? Color.fromARGB(255, 255, 20, 3)
                                        : Color.fromRGBO(47, 175, 107, 20),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.share, color: Colors.white),
                                  onPressed: () {
                                    MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => kasalarBloc(ApiHandler()),
              child: KasalarListPage(),
            ),
          );
                                    // Dispatch event to fetch details
                                    context.read<kasalarBloc>().add(
                                        Fetchkasadetaylari(kasa.logicalRef));

                                    // Listen for state changes
                                    context
                                        .read<kasalarBloc>()
                                        .stream
                                        .listen((state) {
                                      if (state is kasadetayLoaded) {
                                         
                                        // Generate and share the PDF once details are loaded
                                        _generateAndSharePdf(
                                            kasa, state.kasadetaylar);
                                           
        
                                      } else if (state is kasadetayError) {
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KasaDetayPage(
                                      logicalref: kasa.logicalRef),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is kasalarError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Container();
                },
              ),
            ),
          ),
        ));
  }

  void _exportToExcelWithStyles(List<KasaDto> faturalar) async {
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
        TextCellValue(fatura.bakiye.toString()),
        
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
    var filePath = '${directory.path}/KasaDetayları.xlsx';

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);
    OpenFile.open(filePath);
  }

  void _generateAndSharePdf(
      KasaDto kasa, List<KasaDetaylar> details) async {
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
              pw.Text('Kasa Hareketleri',
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
                    pw.Text('Kasa: ${kasa.name}',
                        style: pw.TextStyle(
                            fontSize: 16, color: textColor, font: ttf)),
                    pw.Text('Kodu: ${kasa.code}',
                        style: pw.TextStyle(
                            fontSize: 16, color: textColor, font: ttf)),
                   
                    pw.Text('Bakiyesi: ${kasa.bakiye.toString()}',
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
                        child: pw.Text('Cari Hesap',
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
                        child: pw.Text('Tarih',
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
                          child: pw.Text(detail.cariHesap!,
                              style: pw.TextStyle(color: textColor, font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(detail.islem!,
                              style: pw.TextStyle(color: textColor, font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              '${detail.tarih!} ',
                              style: pw.TextStyle(color: textColor, font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              '${detail.tutar!.toStringAsFixed(2)} TL',
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
    final file = File("${output.path}/Kasa_detay.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Kasa Detayları: ${kasa.name}',
    );
  }
}
