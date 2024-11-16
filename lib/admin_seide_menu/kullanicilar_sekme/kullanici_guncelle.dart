import 'package:fitness_dashboard_ui/admin_seide_menu/kullanicilar_sekme/kullanicilar.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';

class KullaniciGuncelle extends StatefulWidget {
  final int? id;
  final String? kullanici_ad;
  final String? sifre;
  final String? lisans_tarihi;
  final String? lisans_bitis_tarihi;
  final List<bool>? yetkiler;
  final List<RaporYetkiler>? rapor_yetkileri;

  KullaniciGuncelle({
    required this.id,
    required this.kullanici_ad,
    required this.sifre,
    required this.lisans_tarihi,
    required this.lisans_bitis_tarihi,
    required this.yetkiler,
    required this.rapor_yetkileri,
  });

  @override
  _KullaniciGuncelleState createState() => _KullaniciGuncelleState();
}

class _KullaniciGuncelleState extends State<KullaniciGuncelle> {
  late TextEditingController _kullaniciAdController;
  late TextEditingController _sifreController;
  late TextEditingController _lisansTarihiController;
  late TextEditingController _lisansBitisTarihiController;

  // Separate options for menus and reports
  List<String> _menuCheckboxOptions = [
    'Dashboard',
    'Cari Hesap',
    'Malzemeler',
    'Alış Faturaları',
    'Satış Faturaları',
    'Bankalar',
    'Çek Ve Senet',
    'Raporlar',
  ];

  late List<bool> _menuCheckboxValues;
  late List<bool> _raporCheckboxValues; // For report checkboxes

  @override
  void initState() {
    super.initState();

    // Initialize text controllers
    _kullaniciAdController = TextEditingController(text: widget.kullanici_ad);
    _sifreController = TextEditingController(
        text: EncryptionHelper.decryptPassword(widget.sifre));

    final DateFormat inputDateFormat = DateFormat('MM/dd/yyyy');
    final DateFormat outputDateFormat = DateFormat('dd/MM/yyyy');

    DateTime? lisansTarihi;
    DateTime? lisansBitisTarihi;

    try {
      lisansTarihi = inputDateFormat.parse(widget.lisans_tarihi!);
      lisansBitisTarihi = inputDateFormat.parse(widget.lisans_bitis_tarihi!);
    } catch (e) {
      print('Error parsing dates: $e');
    }

    _lisansTarihiController = TextEditingController(
      text: lisansTarihi != null ? outputDateFormat.format(lisansTarihi) : '',
    );
    _lisansBitisTarihiController = TextEditingController(
      text: lisansBitisTarihi != null
          ? outputDateFormat.format(lisansBitisTarihi)
          : '',
    );

    // Initialize the menu checkbox values
    _menuCheckboxValues = List.from(widget.yetkiler!);

    // Initialize the rapor checkbox values from the rapor_yetkileri
    _raporCheckboxValues = widget.rapor_yetkileri!
        .map((raporYetki) =>
            raporYetki.yetki == 1) // Assuming 1 means true (checked)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child:Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title:
              Text('Kullanıcı Güncelle', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromRGBO(36, 64, 72, 1),
        ),
        backgroundColor: Color.fromRGBO(36, 64, 72, 1),
        body: BlocProvider(
          create: (context) =>
              AdminBloc(ApiHandler())..add(FetchYetkiler(widget.id!)),
          child: BlocListener<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state is YetkilerFetched) {
                if (state.checkboxes.length == _menuCheckboxValues.length) {
                  setState(() {
                    _menuCheckboxValues = state.checkboxes;
                  });
                }
              }
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _kullaniciAdController,
                        decoration: InputDecoration(
                          labelText: 'Kullanıcı Adı',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _sifreController,
                        decoration: InputDecoration(
                          labelText: 'Şifre',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _lisansTarihiController,
                        decoration: InputDecoration(
                          labelText: 'Lisans Tarihi',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () =>
                            _selectDate(context, _lisansTarihiController),
                        style: TextStyle(color: Colors.white),
                        readOnly: true,
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _lisansBitisTarihiController,
                        decoration: InputDecoration(
                          labelText: 'Lisans Bitiş Tarihi',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () =>
                            _selectDate(context, _lisansBitisTarihiController),
                        style: TextStyle(color: Colors.white),
                        readOnly: true,
                      ),
                      SizedBox(height: 16.0),
      
                      Text('Menü Yetkileri',
                          style: TextStyle(color: Colors.white)),
                      Column(
                        children:
                            List.generate(_menuCheckboxOptions.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CheckboxListTile(
                              title: Text(_menuCheckboxOptions[index],
                                  style: TextStyle(color: Colors.white)),
                              value: _menuCheckboxValues[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _menuCheckboxValues[index] = value ?? false;
                                });
                              },
                              activeColor: Color.fromRGBO(
                                  241, 108, 39, 1), // Checked color
                              tileColor: Color.fromRGBO(
                                  54, 78, 96, 0.2), // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Optional: Rounded corners
                              ),
                            ),
                          );
                        }),
                      ),
      
                      SizedBox(height: 16.0),
      
                      if (widget.rapor_yetkileri != null &&
                          widget.rapor_yetkileri!.isNotEmpty) ...[
                        Text('Rapor Yetkileri',
                            style: TextStyle(color: Colors.white)),
                        Column(
                          children: List.generate(widget.rapor_yetkileri!.length,
                              (index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CheckboxListTile(
                                title: Text(
                                  widget.rapor_yetkileri![index].raporAdi ??
                                      "Unknown Rapor",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: _raporCheckboxValues[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _raporCheckboxValues[index] = value ?? false;
                                  });
                                },
                                activeColor: Color.fromRGBO(
                                    241, 108, 39, 1), // Checked color
                                tileColor: Color.fromRGBO(
                                    54, 78, 96, 0.2), // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Optional: Rounded corners
                                ),
                              ),
                            );
                          }),
                        ),
                      ] else ...[
                        // Optionally show a message when there are no rapor yetkileri
                        Text('Henüz Rapor Bulunmamaktadır',
                            style: TextStyle(color: Colors.white)),
                      ],
      
                      SizedBox(height: 16.0),
      
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        child: Text('Güncelle',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Color.fromRGBO(241, 108, 39, 1))),
                        onPressed: () {
                          if (_validateInputs()) {
                            DateTime lisansTarihi = DateFormat('dd/MM/yyyy')
                                .parse(_lisansTarihiController.text);
                            DateTime lisansBitisTarihi = DateFormat('dd/MM/yyyy')
                                .parse(_lisansBitisTarihiController.text);
      
                            String formattedLisansTarihi =
                                DateFormat('yyyy-MM-dd').format(lisansTarihi);
                            String formattedLisansBitisTarihi =
                                DateFormat('yyyy-MM-dd')
                                    .format(lisansBitisTarihi);
      
                            // Update yetki values based on checkboxes
                            List<bool> yetkiler = _menuCheckboxValues
                                .map((checked) => checked ? true : false)
                                .toList();
      
                            // Collect report authority changes
                            List<RaporYetkiler> updatedRaporYetkileri = widget
                                .rapor_yetkileri!
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              RaporYetkiler rapor = entry.value;
                              rapor.yetki = _raporCheckboxValues[index] ? 1 : 0;
                              rapor.raporAdi =
                                  widget.rapor_yetkileri![index].raporAdi;
                              rapor.raporId =
                                  widget.rapor_yetkileri![index].raporId;
                              rapor.raporSorgusu =
                                  widget.rapor_yetkileri![index].raporSorgusu;
                              return rapor;
                            }).toList();
                            // Add update user event with the updated data
                            context.read<AdminBloc>().add(UpdateKullanici(
                                  widget.id!,
                                  _kullaniciAdController.text,
                                  EncryptionHelper.encryptPassword(
                                      _sifreController.text),
                                  formattedLisansTarihi,
                                  formattedLisansBitisTarihi,
                                  yetkiler,
                                  updatedRaporYetkileri,
                                ));
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  // Validate inputs
  bool _validateInputs() {
    if (_kullaniciAdController.text.isEmpty) {
      _showErrorDialog('Lütfen kullanıcı adı girin.');
      return false;
    }
    if (_sifreController.text.isEmpty) {
      _showErrorDialog('Lütfen şifre girin.');
      return false;
    }
    if (_lisansTarihiController.text.isEmpty) {
      _showErrorDialog('Lütfen lisans tarihi girin.');
      return false;
    }
    if (_lisansBitisTarihiController.text.isEmpty) {
      _showErrorDialog('Lütfen lisans bitiş tarihi girin.');
      return false;
    }
    return true;
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Date picker
  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    setState(() {
      controller.text = DateFormat('dd/MM/yyyy').format(pickedDate!);
    });
    }
}
