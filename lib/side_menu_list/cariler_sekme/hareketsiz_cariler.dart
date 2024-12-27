import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For date formatting

class HareketsizCarilerPage extends StatefulWidget {
  @override
  _HareketsizCarilerPageState createState() => _HareketsizCarilerPageState();
}

class _HareketsizCarilerPageState extends State<HareketsizCarilerPage> {
  DateTime? _startDate =
      DateTime(DateTime.now().year,DateTime.now().month, 1); // Start of current year
  DateTime? _endDate =
      DateTime(DateTime.now().year,DateTime.now().month + 1, 1); // Start of next year
  String _searchText = "";
  List<HareketsizCariler> _fetchedData = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Initial fetch with default dates
  }

  void _fetchData() {
    if (_startDate != null && _endDate != null) {
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(_startDate!);
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate!);

      // Dispatch the event to fetch data
      context.read<CariHesapBloc>().add(FetchHareketsizCariHesaplar(
            formattedStartDate,
            formattedEndDate,
          ));
    }
  }

  void _pickDate({required bool isStartDate}) async {
    final initialDate = isStartDate ? _startDate : _endDate ?? DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      locale: Locale('tr'),
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
      _fetchData(); // Fetch data after selecting the date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 55, 69, 10),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        title: Text(
          'Hareketsiz Cari Hesaplar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
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
                    color: Color.fromRGBO(65, 190, 184, 20),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Date Pickers
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isStartDate: true),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(65, 190, 184, 1),
                      ),
                      child: Text(
                        _startDate == null
                            ? 'Başlangıç Tarihi'
                            : DateFormat('yyyy-MM-dd').format(_startDate!),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(isStartDate: false),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(65, 190, 184, 1),
                      ),
                      child: Text(
                        _endDate == null
                            ? 'Select End Date'
                            : DateFormat('yyyy-MM-dd').format(_endDate!),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Local Search in Fetched Data

            // Bloc Consumer for state management
            Expanded(
              child: BlocConsumer<CariHesapBloc, CariHesapState>(
                listener: (context, state) {
                  if (state is HareketsizCariHesapError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is HareketsizCariHesapLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is HareketsizCariHesapLoaded) {
                    _fetchedData = state.hareketsiz_cariler;

                    // Apply local search filtering
                    final filteredData = _fetchedData
                        .where((item) =>
                            item.definition
                                ?.toLowerCase()
                                .contains(_searchText) ??
                            false)
                        .toList();

                    if (filteredData.isEmpty) {
                      return Center(child: Text('No data found'));
                    }

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return Card(
                          color: Color.fromRGBO(45, 65, 80, 50),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 15),
                            onTap: () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CariHesapDetailPage(
                                      logicalref: item.logicalref!,
                                    ),
                                  ),
                                );
                              
                            },
                            title: Text(item.definition ?? 'N/A',style: TextStyle(
                                    color: Color.fromRGBO(85, 185, 180, 20),
                                    fontSize: 19),),
                            subtitle: Text('Code: ${item.code ?? 'N/A'}', style: TextStyle(
                                        color: Colors.white, fontSize: 15),),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                
                                Text('Tel: ${item.tel ?? 'N/A'}', style: TextStyle(
                                        color: Colors.white, fontSize: 15),),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is HareketsizCariHesapError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Center(child: Text('No data to display'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
