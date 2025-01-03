import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/screens/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RaporEkle extends StatefulWidget {
  RaporEkle();

  @override
  _RaporEkleState createState() => _RaporEkleState();
}

class _RaporEkleState extends State<RaporEkle> {
  late TextEditingController _kullaniciAdController;
  late TextEditingController _sifreController;

  @override
  void initState() {
    super.initState();
    _kullaniciAdController = TextEditingController();
    _sifreController = TextEditingController();
  }

  bool _validateInputs() {
    String errorMessage = '';

    if (_kullaniciAdController.text.isEmpty) {
      errorMessage = 'Kullanıcı Adı boş olamaz.';
    } else if (_sifreController.text.isEmpty) {
      errorMessage = 'Şifre boş olamaz.';
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
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(0.9)),
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                title: Text(
                  'Rapor Ekle',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color.fromRGBO(36, 64, 72, 1),
              ),
              backgroundColor: Color.fromRGBO(36, 64, 72, 1),
              body: BlocListener<AdminBloc, AdminState>(
                listener: (context, state) {
                  String message;

                  if (state is RaporAdded) {
                    message = 'Rapor başarıyla eklendi.';
                    Navigator.of(context).pop();
                    context.read<AdminBloc>().add(FetchRaporlar());
                  } else if (state is RaporAddError) {
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
                            labelText: 'Rapor Adı',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _sifreController,
                          decoration: InputDecoration(
                            labelText: 'Sql',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.white),
                          obscureText: false,
                        ),
                        SizedBox(height: 16.0),
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
                              context.read<AdminBloc>().add(
                                    AddRapor(
                                      _kullaniciAdController.text,
                                      (_sifreController.text),
                                    ),
                                  );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => AdminBloc(ApiHandler())
                                      ..add(FetchRaporlar()),
                                    child: AdminScreen(),
                                  ),
                                ),
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Rapor Bilgileri Başarıyla Eklendi.')),
                            );
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => AdminBloc(ApiHandler())
                                    ..add(FetchRaporlar()),
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
    super.dispose();
  }
}
