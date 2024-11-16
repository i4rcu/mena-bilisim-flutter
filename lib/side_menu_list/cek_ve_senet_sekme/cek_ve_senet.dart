import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bloc/bloc/cekvesenet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:intl/intl.dart';

class CekVeSenetPage extends StatefulWidget {
  @override
  _CekVeSenetPageState createState() => _CekVeSenetPageState();
}

class _CekVeSenetPageState extends State<CekVeSenetPage> {
  late CekvesenetBloc _cekveSenetBloc;
  String _selectedRaportur = 'Kendi Senetlerimiz';
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _dropdownItems = [
    'Portföydeki Çekler',
    'Portföydeki Senetler',
    'Ciro Edilen Çekler',
    'Ciro Edilen Senetler',
    'Tahsile(Takasa) Verilen Çekler',
    'Tahsile Verilen Senetler',
    'Teminata Verilen Çekler',
    'Teminata Verilen Senetler',
    'Kendi Çekimiz',
    'Kendi Senetlerimiz',
    'Tümü'
  ];

  @override
  void initState() {
    super.initState();
    _cekveSenetBloc = CekvesenetBloc(ApiHandler());
    _loadData();
  }

  void _loadData() {
    _cekveSenetBloc.add(
      LoadCekVeSenet(
        prefix: "prefix",
        suffix: "suffix",
        raportur: _selectedRaportur,
      ),
    );
  }

  @override
  void dispose() {
    _cekveSenetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cekveSenetBloc,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Çek ve Senetler'),
          backgroundColor: Color.fromRGBO(36, 64, 72, 1),
        ),
        backgroundColor: Color.fromRGBO(36, 64, 72, 1),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 10),
              _buildDatePickers(),
              SizedBox(height: 10),
              _buildDropdown(),
              SizedBox(height: 20),
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
        hintText: 'Borçluya göre ara',
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

  Widget _buildDatePickers() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, isStartDate: true),
            child: _buildDateField('Başlangıç Tarihi', _startDate),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, isStartDate: false),
            child: _buildDateField('Bitiş Tarihi', _endDate),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(56, 74, 82, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date != null ? "${date.day}.${date.month}.${date.year}" : label,
            style: TextStyle(color: Colors.white),
          ),
          Icon(Icons.calendar_today, color: Colors.white),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        locale: Locale('tr', 'TR'));
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(56, 74, 82, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: _selectedRaportur,
        isExpanded: true,
        dropdownColor: Color.fromRGBO(56, 74, 82, 1),
        iconEnabledColor: Colors.white,
        underline: SizedBox(),
        style: TextStyle(color: Colors.white, fontSize: 16),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedRaportur = newValue;
            });
            _loadData();
          }
        },
        items: _dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataTable() {
    return BlocBuilder<CekvesenetBloc, CekvesenetState>(
      builder: (context, state) {
        if (state is CekVeSenetLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CekVeSenetLoadaed) {
          List<Cek> filteredCekler = _filterCekler(state.Cekler);

          if (filteredCekler.isEmpty) {
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      WidgetStateColor.resolveWith((states) => Colors.teal),
                  dataRowColor: WidgetStateColor.resolveWith(
                      (states) => Color.fromRGBO(56, 74, 82, 1)),
                  columns: _buildDataColumns(),
                  rows: _buildDataRows(filteredCekler),
                ),
              ),
            );
          }
        } else if (state is CekVeSenetLoadFailure) {
          return Center(
            child: Text(
              'Hata: ${state.error}',
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
        label: Text('Tarih', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('İşlem Türü', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Durumu', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Portföy No', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Borçlu', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Banka Adı', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Vade', style: TextStyle(color: Colors.white)),
      ),
      DataColumn(
        label: Text('Tutar', style: TextStyle(color: Colors.white)),
        numeric: true,
      ),
    ];
  }

  List<DataRow> _buildDataRows(List<Cek> cekler) {
    return cekler.map((cek) {
      return DataRow(
        cells: [
          DataCell(Text(cek.date ?? '', style: TextStyle(color: Colors.white))),
          DataCell(
              Text(cek.islemtur ?? '', style: TextStyle(color: Colors.white))),
          DataCell(
              Text(cek.durumu ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.portfoyno?.toString() ?? '',
              style: TextStyle(color: Colors.white))),
          DataCell(
              Text(cek.borclu ?? '', style: TextStyle(color: Colors.white))),
          DataCell(
              Text(cek.bankname ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(cek.vade ?? '', style: TextStyle(color: Colors.white))),
          DataCell(Text(
            cek.amount?.toStringAsFixed(2) ?? '',
            style: TextStyle(color: Colors.white),
          )),
        ],
      );
    }).toList();
  }

  List<Cek> _filterCekler(List<Cek> cekler) {
    final dateFormat = DateFormat('dd.MM.yyyy'); // Define the date format

    return cekler.where((cek) {
      // Filter by Borçlu
      final matchBorclu =
          cek.borclu?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false;

      // Filter by Date
      DateTime? cekDate;
      if (cek.date != null) {
        try {
          cekDate =
              dateFormat.parse(cek.date!); // Parse using the correct format
        } catch (e) {
          print(
              'Date parsing failed for: ${cek.date}'); // Debug if parsing fails
        }
      }

      final matchDate = (cekDate != null) &&
          (_startDate == null || cekDate.isAfter(_startDate!)) &&
          (_endDate == null || cekDate.isBefore(_endDate!));

      // Debugging prints for date match
      print('Borçlu match: $matchBorclu, Date match: $matchDate');

      // Include only if both Borçlu and date match
      return matchBorclu && matchDate;
    }).toList();
  }
}