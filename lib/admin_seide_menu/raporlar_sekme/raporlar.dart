import 'dart:typed_data';
import 'package:fitness_dashboard_ui/admin_seide_menu/raporlar_sekme/rapor_guncelle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RaporlarPage extends StatefulWidget {
  @override
  _RaporlarPageState createState() => _RaporlarPageState();
}

class _RaporlarPageState extends State<RaporlarPage> with RouteAware {
  String _searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    // When navigating back to this page, refetch the reports
    context.read<AdminBloc>().add(FetchRaporlar());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => AdminBloc(ApiHandler())..add(FetchRaporlar()),
          child: RaporlarPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(ApiHandler())..add(FetchRaporlar()),
      child:  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(35, 55, 69, 10),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromRGBO(35, 55, 69, 10),
            title: const Text(
              'Tüm Raporlar',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _resetFilters,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Ara',
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(68, 192, 186, 10),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(65, 190, 184, 20),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          suffixIcon: const Icon(
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
                  ],
                ),
              ),
            ),
          ),
          body: BlocListener<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state is RaporlarFetched) {
                // No need to refetch immediately since data is already fetched
              } else if (state is RaporDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rapor Başarıyla Silindi.')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) =>
                          AdminBloc(ApiHandler())..add(FetchRaporlar()),
                      child: RaporlarPage(),
                    ),
                  ),
                );
              } else if (state is RaporDeleteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rapor silme işlemi başarısız.')),
                );
              }
            },
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminInitial || state is RaporlarFetching) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RaporlarFetched) {
                  final filteredRaporlar = state.raporlar.where((rapor) {
                    final raporAdi = rapor.raporAdi?.toLowerCase() ?? '';
                    return raporAdi.contains(_searchQuery);
                  }).toList();
        
                  return ListView.builder(
                    itemCount: filteredRaporlar.length,
                    itemBuilder: (context, index) {
                      final rapor = filteredRaporlar[index];
        
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: const Color.fromRGBO(45, 65, 80, 50),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(this.context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => AdminBloc(ApiHandler()),
                                    child: RaporGuncelle(
                                      rapor_adi: rapor.raporAdi,
                                      rapor_sorgusu: rapor.raporSorgusu,
                                      rapor_id: rapor.raporId,
                                    ),
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              rapor.raporAdi ?? '',
                              style: const TextStyle(
                                  color: Color.fromRGBO(85, 185, 180, 20),
                                  fontSize: 19),
                            ),
                            subtitle: Text(
                              'Sql : ${rapor.raporSorgusu ?? ''}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Rapor Sil'),
                                      content: const Text(
                                          'Bu Raporu silmek istediğinize emin misiniz?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('İptal'),
                                          onPressed: () {
                                            Navigator.of(dialogContext)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Sil'),
                                          onPressed: () {
                                            context
                                                .read<AdminBloc>()
                                                .add(DeleteRapor(rapor.raporId));
        
                                            // Close the dialog
                                            Navigator.of(dialogContext).pop();
        
                                            // Optionally refresh the list or display a message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Rapor silme işlemi yapılıyor...')),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is RaporlarFetchingError) {
                  return const Center(child: Text('Veri Yüklenemedi'));
                } else {
                  return Center(child: Text(""));
                }
              },
            ),
          ),
        ),
      ),
    ));
  }
}

// Encryption Helper class
class EncryptionHelper {
  static final key = encrypt.Key(Uint8List.fromList(
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]));
  static final iv = encrypt.IV(Uint8List.fromList(
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]));

  static String encryptPassword(String password) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  static String decryptPassword(String? encryptedPassword) {
    if (encryptedPassword == null) return ''; // Handle null case safely
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
    return decrypted;
  }
}
