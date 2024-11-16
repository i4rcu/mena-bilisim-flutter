import 'package:flutter/material.dart';

class ReportDataPage extends StatelessWidget {
  final List<Map<String, dynamic>> data; // Data passed from the previous page
  final String name;
  
  ReportDataPage({required this.data, required this.name});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(34, 54, 69, 20),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(36, 64, 72, 1),
          title: Text(name),
        ),
        body: Center(
          child: Text('No data available for this report.', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // Extract the headers from the data (keys of the first row)
    List<String> headers = data[0].keys.toList();

    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 54, 69, 20),
      appBar: AppBar(
        title: Text(name),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(36, 64, 72, 1),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Enable vertical scrolling
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: headers.map((header) => DataColumn(
                  label: Text(header, style: TextStyle(color: Colors.white)),
                )).toList(),
                rows: data.map((row) {
                  return DataRow(
                    cells: row.values.map((value) => DataCell(
                      Text(value.toString(), style: TextStyle(color: Colors.white)),
                    )).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
