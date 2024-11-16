import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';

class AllItemsPage extends StatefulWidget {
  @override
  _AllItemsPageState createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  String searchQuery = '';
  late List<HMalzeme> filteredItems;

  @override
  void initState() {
    super.initState();
    // Trigger the FetchHmalzeme event to load data
    BlocProvider.of<MalzemelerBloc>(context).add(FetchHmalzeme());
  }

  // Update the filtered list whenever the search query changes
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredItems = filteredItems
          .where((item) =>
              (item.name != null && item.name!.toLowerCase().contains(searchQuery)) ||
              (item.code != null && item.code!.toLowerCase().contains(searchQuery)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 55, 69, 10),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        title: Text('Hareket Görmeyen Malzemeler', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MalzemelerBloc, MalzemelerState>(
        builder: (context, state) {
          if (state is HmlazemeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is Hmalzemeloaded) {
            filteredItems = state.HMALZEMELER;

            return Column(
              children: [
                // Search bar at the top
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Malzeme adına veya koduna göre ara..',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: updateSearchQuery, // Update the list when typing
                  ),
                ),
                // Display filtered items in Card view
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color.fromRGBO(45, 65, 80, 50),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ?? '',
                                  style: TextStyle(
                                    color: Color.fromRGBO(85, 185, 180, 20),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  item.code ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is HmalzemeError) {
            return Center(child: Text('Veri Yüklenemedi: ${state.message}'));
          } else {
            return Center(child: Text('Beklenmedik bir hata oluştu'));
          }
        },
      ),
    );
  }
}
