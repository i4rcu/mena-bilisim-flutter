import 'package:fitness_dashboard_ui/EncryptionHelper.dart';
import 'package:fitness_dashboard_ui/admin_seide_menu/kullanicilar_sekme/kullanicilar.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/screens/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KullaniciEkle extends StatefulWidget {
  KullaniciEkle();

  @override
  _KullaniciEkleState createState() => _KullaniciEkleState();
}

class _KullaniciEkleState extends State<KullaniciEkle> {
  late TextEditingController _kullaniciAdController;
  late TextEditingController _sifreController;
  late TextEditingController _lisansTarihiController;
  late TextEditingController _lisansBitisTarihiController;

  List<String> _checkboxOptions = [
    'Dashboard',
    'Cari Hesap',
    'Malzemeler',
    'Alış Faturaları',
    'Satış Faturaları',
    'Bankalar',
    'Çek Ve Senet',
    'Raporlar',
  ];

  List<bool> _checkboxValues = List.generate(8, (index) => false);

  @override
  void initState() {
    super.initState();
    _kullaniciAdController = TextEditingController();
    _sifreController = TextEditingController();
    _lisansTarihiController = TextEditingController();
    _lisansBitisTarihiController = TextEditingController();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.tryParse(controller.text) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: Locale('tr'));
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  bool _validateInputs() {
    String errorMessage = '';

    if (_kullaniciAdController.text.isEmpty) {
      errorMessage = 'Kullanıcı Adı boş olamaz.';
    } else if (_sifreController.text.isEmpty) {
      errorMessage = 'Şifre boş olamaz.';
    } else if (_lisansTarihiController.text.isEmpty) {
      errorMessage = 'Lisans Tarihi seçilmelidir.';
    } else if (_lisansBitisTarihiController.text.isEmpty) {
      errorMessage = 'Lisans Bitiş Tarihi seçilmelidir.';
    } else {}

    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AdminBloc(ApiHandler()),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler:
                  TextScaler.linear(0.9)), 
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                title: Text(
                  'Kullanıcı Ekle',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color.fromRGBO(36, 64, 72, 1),
              ),
              backgroundColor: Color.fromRGBO(36, 64, 72, 1),
              body: BlocListener<AdminBloc, AdminState>(
                listener: (context, state) {
                  String message;

                  if (state is KullaniciAdded) {
                    message = 'Kullanıcı başarıyla eklendi.';
                    Navigator.of(context).pop(); 

                    context.read<AdminBloc>().add(FetchKullanicilar());
                  } else if (state is KullaniciAddError) {
                    message = 'Kullanıcı eklenemedi. Lütfen tekrar deneyin.';
                  } else {
                    return; 
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                  ));
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
                          onTap: () => _selectDate(
                              context, _lisansBitisTarihiController),
                          style: TextStyle(color: Colors.white),
                          readOnly: true, 
                        ),
                        SizedBox(height: 16.0),
                        Column(
                          children:
                              List.generate(_checkboxOptions.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CheckboxListTile(
                                title: Text(
                                  _checkboxOptions[index],
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: _checkboxValues[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _checkboxValues[index] = value ?? false;
                                  });
                                },
                                activeColor: Color.fromRGBO(
                                    241, 108, 39, 1), 
                                tileColor: Color.fromRGBO(
                                    54, 78, 96, 0.2), 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), 
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          child: Text('Ekle',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Color.fromRGBO(241, 108, 39, 20))),
                          onPressed: () {
                            if (_validateInputs()) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => AdminBloc(ApiHandler())
                                      ..add(FetchKullanicilar()),
                                    child: AdminScreen(),
                                  ),
                                ),
                              );
                              DateTime lisansTarihi = DateFormat('dd/MM/yyyy')
                                  .parse(_lisansTarihiController.text);
                              DateTime lisansBitisTarihi =
                                  DateFormat('dd/MM/yyyy')
                                      .parse(_lisansBitisTarihiController.text);
                              context.read<AdminBloc>().add(
                                    AddKullanici(
                                      _kullaniciAdController.text,
                                      EncryptionHelper.encryptPassword(
                                          _sifreController.text),
                                      DateEncryptor().encrypt(
                                          (lisansTarihi)), 
                                      DateEncryptor().encrypt(
                                          lisansBitisTarihi), 
                                      _checkboxValues, 
                                    ),
                                  );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Kullanıcı Bilgileri Başarıyla Eklendi.')),
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => AdminBloc(ApiHandler())
                                    ..add(FetchKullanicilar()),
                                  child: AdminScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _kullaniciAdController.dispose();
    _sifreController.dispose();
    _lisansTarihiController.dispose();
    _lisansBitisTarihiController.dispose();
    super.dispose();
  }
}
