import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';

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
    _loadData();
  }

  void _loadData() {
    _MalzemeBloc.add(FetchSatilanMalzeme());
  }

  @override
  void dispose() {
    _MalzemeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _MalzemeBloc,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Hangi Malzeme Kime Satıldı'),
          backgroundColor: Color.fromRGBO(36, 64, 72, 1),
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
    );
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
        List<HangiMalzemeKimeSatildi> filteredAndSortedCekler = _sortCekler(_filterCekler(state.SATILANMALZEMELER));

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
}