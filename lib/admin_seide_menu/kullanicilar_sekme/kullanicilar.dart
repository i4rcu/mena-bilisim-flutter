import 'dart:typed_data';

import 'package:fitness_dashboard_ui/admin_seide_menu/kullanicilar_sekme/kullanici_guncelle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> with RouteAware {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortBy = 'Tarih';
  bool _isAscending = true;
  final formatter1 = NumberFormat('#,##0.00', 'tr_TR');
  final DateFormat _displayDateFormat = DateFormat('dd.MM.yyyy');
  final DateFormat _apiDateFormat = DateFormat('MM/dd/yyyy');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the RouteObserver
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the current route shows up
    BlocProvider.of<AdminBloc>(context).add(FetchKullanicilar());
  }

  @override
  void dispose() {
    // Unsubscribe from the RouteObserver
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _startDate = null;
      _endDate = null;
      _sortBy = 'Tarih';
      _isAscending = true;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => AdminBloc(ApiHandler())..add(FetchKullanicilar()),
          child: KullanicilarPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AdminBloc(ApiHandler())..add(FetchKullanicilar()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color.fromRGBO(35, 55, 69, 10),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(35, 55, 69, 10),
          title: Text(
            'Tüm Kullanicilar',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: _resetFilters,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(65),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Ara',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(68, 192, 186, 10),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(65, 190, 184, 20),
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Color.fromRGBO(65, 190, 184, 1),
                            ),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              locale: Locale('tr'),
                            );
                            if (selectedDate != null &&
                                selectedDate != _startDate) {
                              setState(() {
                                _startDate = selectedDate;
                              });
                            }
                          },
                          child: Text(
                            _startDate != null
                                ? _displayDateFormat.format(_startDate!)
                                : 'Başlangıç Tarihi',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Color.fromRGBO(65, 190, 184, 1),
                            ),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              locale: Locale('tr'),
                            );
                            if (selectedDate != null &&
                                selectedDate != _endDate) {
                              setState(() {
                                _endDate = selectedDate;
                              });
                            }
                          },
                          child: Text(
                            _endDate != null
                                ? _displayDateFormat.format(_endDate!)
                                : 'Bitiş Tarihi',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocListener<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is KullaniciUpdated) {
              // Refresh the user list when the user is updated successfully
              context.read<AdminBloc>().add(FetchKullanicilar());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => KullanicilarPage(),
                ),
              );
            } else if (state is KullanicilarLoaded) {
            } else if (state is KullaniciDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Kullanıcı Bilgileri Başarıyla Silindi.')),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (_) =>
                        AdminBloc(ApiHandler())..add(FetchKullanicilar()),
                    child: KullanicilarPage(),
                  ),
                ),
              );
            } else if (state is KullaniciDeleteError) {
              Navigator.of(context).pop(); // Close progress dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Kullanıcı silme işlemi başarısız.')),
              );
            }
          },
          child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              if (state is AdminInitial) {
                return Center(child: Text('Listelenecek kayıt yok'));
              } else if (state is KullanicilarError) {
                return Center(child: CircularProgressIndicator());
              } else if (state is KullanicilarLoaded) {
                final filteredCariHesaplar = state.kullanicilar.where((cariHesap) {
  final definition = cariHesap.kullaniciAd?.toLowerCase() ?? '';
  final trCode = cariHesap.kullaniciAd?.toLowerCase() ?? '';

  DateTime? startDate = _startDate; // Use _startDate if it is set
  DateTime? endDate = _endDate; // Use _endDate if it is set
  DateTime? date;
  DateTime? date2;

  if (cariHesap.lisansTarihi != null && cariHesap.lisansBitisTarihi != null) {
    try {
      date = _apiDateFormat.parse(cariHesap.lisansTarihi!); // Start date of user
      date2 = _apiDateFormat.parse(cariHesap.lisansBitisTarihi!); // End date of user
    } catch (e) {
      print('Date parsing error: $e');
    }
  }

  // Only use _endDate if _startDate is null
  final isDateInRange = (_startDate == null || 
                        (date != null && date.isAfter(_startDate!.subtract(Duration(days: 1))))) &&
                      (_endDate == null || 
                        (date2 != null && date2.isBefore(_endDate!.add(Duration(days: 1)))));

  return (definition.contains(_searchQuery) || trCode.contains(_searchQuery)) && isDateInRange;
}).toList();
                // Sorting logic remains unchanged...
                filteredCariHesaplar.sort((a, b) {
                  int comparisonResult;

                  if (_sortBy == 'Tarih') {
                    DateTime dateA = _apiDateFormat.parse(a.lisansTarihi!);
                    DateTime dateB = _apiDateFormat.parse(b.lisansBitisTarihi!);
                    comparisonResult = dateB.compareTo(dateA);
                  } else if (_sortBy == 'Tutar') {
                    comparisonResult = a.sifre!.compareTo(b.sifre!);
                  } else {
                    comparisonResult = 0;
                  }

                  if (comparisonResult == 0) {
                    comparisonResult =
                        (a.kullaniciAd ?? '').compareTo(b.kullaniciAd ?? '');
                  }

                  return _isAscending ? comparisonResult : -comparisonResult;
                });

                return ListView.builder(
                  itemCount: filteredCariHesaplar.length,
                  itemBuilder: (context, index) {
                    final cariHesap = filteredCariHesaplar[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color.fromRGBO(45, 65, 80, 50),
                        child: ListTile(
                          onTap: () async {
                            // Trigger FetchYetkiler event when the card is clicked
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => AdminBloc(ApiHandler())
                                    ..add(FetchYetkiler(cariHesap.id!)),
                                  child: BlocConsumer<AdminBloc, AdminState>(
                                    listener: (context, state) {
                                      if (state is YetkilerFetched) {
                                        // Navigate to KullaniciGuncelle when YetkilerFetched
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                              create: (context) =>
                                                  AdminBloc(ApiHandler()),
                                              child: KullaniciGuncelle(
                                                id: cariHesap.id,
                                                kullanici_ad:
                                                    cariHesap.kullaniciAd,
                                                lisans_bitis_tarihi:
                                                    cariHesap.lisansBitisTarihi,
                                                lisans_tarihi:
                                                    cariHesap.lisansTarihi,
                                                sifre: cariHesap.sifre,
                                                yetkiler: state.checkboxes,
                                                rapor_yetkileri:
                                                    state.rapor_checkboxes,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (state
                                          is KullaniciUpdateError) {
                                        // Show an error SnackBar if there is an error in the process
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Yetkiler yüklenirken hata oluştu: ${state.message}')),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is KullaniciUpdating) {
                                        // Show a loading indicator while fetching data
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        // Default widget when no loading
                                        return Container(); // or any other widget you want here
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          title: Text(
                            cariHesap.kullaniciAd ?? '',
                            style: TextStyle(
                                color: Color.fromRGBO(85, 185, 180, 20),
                                fontSize: 19),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Şifre: ${EncryptionHelper.decryptPassword(cariHesap.sifre!)}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text(
                                _displayDateFormat.format(_apiDateFormat
                                        .parse(cariHesap.lisansTarihi!)) +
                                    " - " +
                                    _displayDateFormat.format(_apiDateFormat
                                        .parse(cariHesap.lisansBitisTarihi!)),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                          trailing: BlocProvider(
                            create: (context) => AdminBloc(ApiHandler()),
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Show a confirmation dialog before deleting the user
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return BlocProvider(
                                      create: (context) =>
                                          AdminBloc(ApiHandler()),
                                      child: AlertDialog(
                                        title: Text('Kullanıcı Sil'),
                                        content: Text(
                                            'Bu kullanıcıyı silmek istediğinize emin misiniz?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('İptal'),
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Sil'),
                                            onPressed: () {
                                              context.read<AdminBloc>().add(
                                                  DeleteKullanici(
                                                      cariHesap.id));

                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is KullanicilarError) {
                return Center(child: Text('Veri Yüklenemedi'));
              } else {
                return Center(child: Text(""),);
              }
            },
          ),
        ),
      ),
    );
  }
}

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
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedPassword!, iv: iv);
    return decrypted;
  }
}
