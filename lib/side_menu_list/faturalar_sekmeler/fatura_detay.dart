import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/alinan_faturala_bloc/alinan_faturalar_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class FaturaDetayDialog extends StatelessWidget {
  final String? name;
  final int? logicalRef;
  final int? tur;
  final String? trcode;
    final String? date;

  FaturaDetayDialog({required this.logicalRef, required this.tur, required this.name, required this.trcode , required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlinanFaturalarBloc(ApiHandler())
        ..add(LoadFaturaDetay(
          prefix: "",
          suffix: "",
          logicalref: logicalRef,
          tur: tur,
        )),
      child: BlocBuilder<AlinanFaturalarBloc, AlinanFaturalarState>(
        builder: (context, state) {
          if (state is FaturaDetayLoadSuccess) {
            return AlertDialog(
              backgroundColor: Color.fromRGBO(36, 64, 72, 50),
              title: Text(
                'Fatura Detayları',
                style: TextStyle(color: Colors.white),
              ),
              content: state.Faturalar.isEmpty
                  ? Text('Fatura detayları boş.')
                  : Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.Faturalar.length,
                        itemBuilder: (context, index) {
                          final fatura = state.Faturalar[index];
                          return ListTile(
                            title: Text(
                              fatura.definitioN ?? "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${fatura.amount?.toString() ?? 'N/A'} adet * ${fatura.brmfyt} TL + ${fatura.vatamnt} TL',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                Text(
                                  'Türü: ${fatura.linetype ?? 'N/A'}',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  "Toplam",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                                Text(
                                  fatura.nettotal.toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Paylaş PDF', // Share PDF button
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await _generateAndSharePdf(
                      state.Faturalar,
                      logicalRef ?? 0,
                    );
                  },
                ),
                TextButton(
                  child: Text(
                    'Kapat',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else if (state is FaturaDetayLoadFailure) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(state.error),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _generateAndSharePdf(List<faturaDetay> faturalar, int logicalRef) async {
  final pdf = pw.Document();

  // Load the font
  final fontData = await rootBundle.load('assets/fonts/NotoSans-VariableFont_wdth,wght.ttf');
  final ttf = pw.Font.ttf(fontData);

  final headerColor = PdfColor.fromHex('#4CAF50');
  final alternateRowColor = PdfColors.grey300;

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Fatura Detayları',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: headerColor,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Detayları:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: headerColor,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 8),
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(color: headerColor, width: 1),
            columnWidths: {
              0: const pw.FlexColumnWidth(3), // "Malzeme Adı" wider
              1: const pw.FlexColumnWidth(2), // "Birim Fiyatı"
              2: const pw.FlexColumnWidth(1), // "Adet"
              3: const pw.FlexColumnWidth(2), // "Toplam Fiyat"
            },
            children: [
              // Table Header Row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: headerColor),
                children: [
                  _tableCell('Malzeme Adı', ttf, isHeader: true),
                  _tableCell('Birim Fiyatı', ttf, isHeader: true),
                  _tableCell('Adet', ttf, isHeader: true),
                  _tableCell('Toplam Fiyat', ttf, isHeader: true),
                ],
              ),
              // Data Rows
              ...faturalar.asMap().entries.map((entry) {
                final index = entry.key;
                final fatura = entry.value;
                final isAlternate = index % 2 == 1;

                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: isAlternate ? alternateRowColor : PdfColors.white,
                  ),
                  children: [
                    _tableCell(fatura.definitioN ?? "", ttf),
                    _tableCell('${fatura.brmfyt?.toStringAsFixed(2) ?? "N/A"} TL', ttf),
                    _tableCell('${fatura.amount ?? 0} adet', ttf),
                    _tableCell('${fatura.nettotal.toString()} TL', ttf),
                  ],
                );
              }).toList(),
            ],
          ),
        ];
      },
    ),
  );

  // Save PDF and share
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/fatura_detay.pdf");
  await file.writeAsBytes(await pdf.save());

  await Share.shareXFiles(
    [XFile(file.path)],
    text: 'Fatura Detayları: LogicalRef - $logicalRef',
  );
}

pw.Widget _tableCell(String text, pw.Font ttf, {bool isHeader = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Align(
      alignment: pw.Alignment.centerLeft, // Align all text to the left
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: ttf,
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColor.fromHex('#212121'),
        ),
      ),
    ),
  );
}




}
