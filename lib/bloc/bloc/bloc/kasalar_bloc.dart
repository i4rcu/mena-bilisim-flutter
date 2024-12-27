import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'kasalar_event.dart';
part 'kasalar_state.dart';

class kasalarBloc extends Bloc<kasalarEvent, kasalarState> {
  final ApiHandler apiHandler;
  kasalarBloc(this.apiHandler) : super(kasalarInitial()) {
    on<Fetchkasalar>(_onFetchkasalar);
    on<Fetchkasadetaylari>(_onFetchkasadetaylar);
  }

  void _onFetchkasalar(
      Fetchkasalar event, Emitter<kasalarState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(kasalarLoading());
    try {
      final kasalar = await apiHandler.fetchKasaDetailsString(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01');
      emit(kasalarLoaded(kasalar));
    } catch (e) {
      emit(kasalarError(e.toString()));
    }
  }
  void _onFetchkasadetaylar(
      Fetchkasadetaylari event, Emitter<kasalarState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(kasadetayLoading());
    try {
      final kasa = await apiHandler.fetchoneKasaDetails(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01',
          event.logicalref
          );
          final kasalar = await apiHandler.fetchKasaDetailsString(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01',
          );
          print(kasalar);
      emit(kasadetayLoaded(kasa,kasalar));
    } catch (e) {
      emit(kasadetayError(e.toString()));
    }
  }
}
