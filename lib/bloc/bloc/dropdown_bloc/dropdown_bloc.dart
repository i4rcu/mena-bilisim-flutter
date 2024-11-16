import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dropdown_event.dart';
import 'dropdown_state.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/UserSession.dart';

class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
  final ApiHandler apiHandler;

  DropdownBloc(this.apiHandler) : super(DropdownInitial()) {
    on<LoadDropdownData>(_onLoadDropdownData);
    on<SelectFirma>(_onSelectFirma);
    on<SelectDonem>(_onSelectDonem);
    on<UpdateSelectedValues>(_onUpdateSelectedValues);
  }

  Future<void> _storeSelectedValues(Firma firma, Donem donem) async {
    var formatter = NumberFormat('000');
    var formatter1 = NumberFormat('00');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFirma', formatter.format(firma.firma));
    await prefs.setString('selectedFirmaName', firma.name);
    await prefs.setString('selectedDonem', formatter1.format(donem.donem));
  }

  Future<void> _onLoadDropdownData(
      LoadDropdownData event, Emitter<DropdownState> emit) async {
    emit(DropdownLoading());
    try {
      final firmas = await apiHandler.Firmalar();
      final selectedFirma = await apiHandler.KullaniciFirmaGetir();
      final selectedDonem = await apiHandler.KullaniciDonemGetir();
      final donems = await apiHandler.DonemGetir(selectedFirma.firma);
      final kasalar = await apiHandler.fetchKasaDetails(
          selectedFirma.firma, selectedDonem.donem);

      final totalBakiye = kasalar.fold(0.0, (sum, kasa) => sum + kasa.bakiye);
      _storeSelectedValues(Firma(firma: selectedFirma.firma, name: selectedFirma.name,),Donem(donem: selectedDonem.donem));
      emit(DropdownLoaded(
        firmas,
        donems,
        selectedFirma,
        selectedDonem,
        totalBakiye,
        kasalar,
      ));
    } catch (e) {
      emit(DropdownError(e.toString()));
    }
  }

  Future<void> _onSelectFirma(
      SelectFirma event, Emitter<DropdownState> emit) async {
    if (state is DropdownLoaded) {
      final loadedState = state as DropdownLoaded;
      try {
        final donemler = await apiHandler.DonemGetir(event.selectedFirma.firma);

        final defaultDonem = donemler.firstWhere((donem) => donem.donem == 1);

        final kasalar = await apiHandler.fetchKasaDetails(
            event.selectedFirma.firma, defaultDonem.donem);
        final totalBakiye = kasalar.fold(0.0, (sum, kasa) => sum + kasa.bakiye);
        await apiHandler.updateSelectedValues(
            event.selectedFirma, defaultDonem, UserSession().userId);
        await _storeSelectedValues(event.selectedFirma, defaultDonem);

        emit(DropdownLoaded(
          loadedState.firmas,
          donemler,
          event.selectedFirma,
          defaultDonem,
          totalBakiye,
          kasalar,
        ));
      } catch (e) {
        emit(DropdownError(e.toString()));
      }
    }
  }

  Future<void> _onSelectDonem(
      SelectDonem event, Emitter<DropdownState> emit) async {
    if (state is DropdownLoaded) {
      final loadedState = state as DropdownLoaded;
      try {
        final donemler =
            await apiHandler.DonemGetir(loadedState.selectedFirma!.firma);

        final kasalar = await apiHandler.fetchKasaDetails(
            loadedState.selectedFirma!.firma, event.selectedDonem.donem);
        final totalBakiye = kasalar.fold(0.0, (sum, kasa) => sum + kasa.bakiye);

        await apiHandler.updateSelectedValues(loadedState.selectedFirma!,
            event.selectedDonem, UserSession().userId);
        await _storeSelectedValues(loadedState.selectedFirma!, event.selectedDonem);

        emit(DropdownLoaded(
          loadedState.firmas,
          donemler,
          loadedState.selectedFirma,
          event.selectedDonem,
          totalBakiye,
          kasalar,
        ));
      } catch (e) {
        emit(DropdownError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateSelectedValues(
      UpdateSelectedValues event, Emitter<DropdownState> emit) async {
    try {
      await apiHandler.updateSelectedValues(
        event.selectedFirma,
        event.selectedDonem,
        UserSession().userId,
      );
    } catch (e) {
      emit(DropdownError(e.toString()));
    }
  }
}
