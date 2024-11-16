import 'package:fitness_dashboard_ui/bloc/bloc/bankalar_bloc/bankalar_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_event.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Buttons extends StatefulWidget {
  final bool isDesktop;

  Buttons({required this.isDesktop});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  var formatter = NumberFormat('000');
  var formatter1 = NumberFormat('00');

  bool _hasFetchedData = false; // Add a flag to track if data has been fetched

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final firma = prefs.getString('selectedFirma');
    final firmaName = prefs.getString('selectedFirmaName');
    final donem = prefs.getString('selectedDonem');

    if (firma != null && firmaName != null && donem != null) {
      final dropdownBloc = BlocProvider.of<DropdownBloc>(context);
      final selectedFirma = Firma(firma: int.parse(firma), name: firmaName);
      final selectedDonem = Donem(donem: int.parse(donem));

      dropdownBloc.add(SelectFirma(selectedFirma));
      dropdownBloc.add(SelectDonem(selectedDonem));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dropdownBloc = BlocProvider.of<DropdownBloc>(context);
    final cari = BlocProvider.of<CariHesapBloc>(context);
    final banka = BlocProvider.of<BankalarBloc>(context);

    return BlocListener<DropdownBloc, DropdownState>(
      listener: (context, state) {
        // Only fetch data if it's not already fetched
        if (state is DropdownLoaded && !_hasFetchedData) {
          if (state.selectedFirma != null) {
            cari.add(FetchCariHesaplar("tablePrefix", "tableSuffix"));
            banka.add(FetchBankalar());
            _hasFetchedData = true; // Mark as fetched
          }
        }
      },
      child: BlocBuilder<DropdownBloc, DropdownState>(
        buildWhen: (previous, current) {
          if (current is DropdownLoaded && previous is DropdownLoaded) {
            return previous.selectedDonem != current.selectedDonem;
          }
          return true;
        },
        builder: (context, state) {
          return Container(
            width: 600,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<Firma>(
                  iconEnabledColor: Colors.white,
                  isDense: true,
                  enableFeedback: true,
                  dropdownColor: Color.fromRGBO(34, 54, 69, 20),
                  borderRadius: BorderRadius.circular(9),
                  style: TextStyle(fontSize: widget.isDesktop ? 16 : 12, color: Colors.white),
                  hint: Text("Firma"),
                  isExpanded: false,
                  menuMaxHeight: 250,
                  value: state is DropdownLoaded ? state.selectedFirma : null,
                  onChanged: (Firma? firma) {
                    if (firma != null) {
                      dropdownBloc.add(SelectFirma(firma)); // Set selected firma
                      // Update data fetch flag
                      _hasFetchedData = false; // Reset flag
                    }
                  },
                  underline: Container(
                    margin: EdgeInsets.only(top: 100),
                    height: 1,
                    color: Colors.white,
                  ),
                  items: state is DropdownLoaded
                      ? [
                          if (state.selectedFirma != null)
                            DropdownMenuItem<Firma>(
                              value: state.selectedFirma,
                              child: SizedBox(
                                width: widget.isDesktop ? 360 : 120,
                                child: Text(
                                  '${formatter.format(state.selectedFirma!.firma)} - ${state.selectedFirma!.name}',
                                ),
                              ),
                            ),
                          ...state.firmas
                              .where((firma) =>
                                  firma.firma != state.selectedFirma?.firma)
                              .map((Firma firma) {
                            return DropdownMenuItem<Firma>(
                              value: firma,
                              child: SizedBox(
                                width: widget.isDesktop ? 360 : 120,
                                child: Text(
                                  '${formatter.format(firma.firma)} - ${firma.name}',
                                ),
                              ),
                            );
                          }).toList(),
                        ]
                      : [],
                ),
                SizedBox(width: 20),
                DropdownButton<Donem>(
                  isDense: true,
                  underline: Container(
                    margin: EdgeInsets.only(top: 100),
                    height: 1,
                    color: Colors.white,
                  ),
                  iconEnabledColor: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  dropdownColor: Color.fromRGBO(34, 54, 69, 20),
                  hint: Text("Dönem"),
                  style: TextStyle(
                    fontSize: widget.isDesktop ? 14 : 12,
                    color: Colors.white,
                  ),
                  isExpanded: false,
                  menuMaxHeight: 200,
                  value: state is DropdownLoaded ? state.selectedDonem : null,
                  onChanged: (Donem? donem) {
                    if (donem != null && state is DropdownLoaded) {
                      dropdownBloc.add(SelectDonem(donem));
                      dropdownBloc.add(UpdateSelectedValues(state.selectedFirma!, donem));
                      // Update data fetch flag
                      _hasFetchedData = false; // Reset flag
                    }
                  },
                  items: state is DropdownLoaded
                      ? [
                          if (state.selectedDonem != null)
                            DropdownMenuItem<Donem>(
                              value: state.selectedDonem,
                              child: SizedBox(
                                width: widget.isDesktop ? 140 : 70,
                                child: Text(formatter1.format(state.selectedDonem!.donem)),
                              ),
                            ),
                          ...state.donems
                              .where((donem) =>
                                  donem.donem != state.selectedDonem?.donem)
                              .map((Donem donem) {
                            return DropdownMenuItem<Donem>(
                              value: donem,
                              child: SizedBox(
                                width: widget.isDesktop ? 140 : 70,
                                child: Text(formatter1.format(donem.donem)),
                              ),
                            );
                          }).toList(),
                        ]
                      : [],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
