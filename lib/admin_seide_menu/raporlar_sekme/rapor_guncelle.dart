import 'package:fitness_dashboard_ui/admin_seide_menu/raporlar_sekme/raporlar.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';

class RaporGuncelle extends StatefulWidget {
  final int? rapor_id;
  final String? rapor_adi;
  final String? rapor_sorgusu;

  RaporGuncelle({
    required this.rapor_id,
    required this.rapor_adi,
    required this.rapor_sorgusu,
  });

  @override
  _RaporGuncelleState createState() => _RaporGuncelleState();
}

class _RaporGuncelleState extends State<RaporGuncelle> {
  late TextEditingController _RaporAdController;
  late TextEditingController _RaporSorgusuController;

  @override
  void initState() {
    super.initState();

    _RaporAdController = TextEditingController(text: widget.rapor_adi);
    _RaporSorgusuController = TextEditingController(text: widget.rapor_sorgusu);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is RaporUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Rapor Bilgileri Başarıyla Güncellendi.')),
            );
            Navigator.of(context).pop();
          } else if (state is RaporUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rapor Güncelleme Başarısız.')),
            );
          }
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler:
                  TextScaler.linear(0.9)), // Force text scale factor to 1.0
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                title: const Text('Rapor Güncelle',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: const Color.fromRGBO(36, 64, 72, 1),
              ),
              backgroundColor: const Color.fromRGBO(36, 64, 72, 1),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _RaporAdController,
                          decoration: const InputDecoration(
                            labelText: 'Rapor Adı',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _RaporSorgusuController,
                          decoration: const InputDecoration(
                            labelText: 'Sql Sorgusu',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          child: const Text(
                            'Güncelle',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                const Color.fromRGBO(241, 108, 39, 1)),
                          ),
                          onPressed: () {
                            if (_validateInputs()) {
                              context.read<AdminBloc>().add(
                                    UpdateRapor(
                                      widget.rapor_id,
                                      _RaporAdController.text,
                                      _RaporSorgusuController.text,
                                    ),
                                  );
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (_) => AdminBloc(ApiHandler())
                                      ..add(FetchRaporlar()),
                                    child: RaporlarPage(),
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
        ));
  }

  bool _validateInputs() {
    String errorMessage = '';

    if (_RaporAdController.text.isEmpty) {
      errorMessage = 'Rapor Adı boş olamaz.';
    } else if (_RaporSorgusuController.text.isEmpty) {
      errorMessage = 'Sql Sorgusu boş olamaz.';
    }

    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _RaporAdController.dispose();
    _RaporSorgusuController.dispose();
    super.dispose();
  }
}
