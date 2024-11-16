import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cekvesenet_event.dart';
part 'cekvesenet_state.dart';

class CekvesenetBloc extends Bloc<CekvesenetEvent, CekvesenetState> {
  final ApiHandler apiHandler;
  CekvesenetBloc(this.apiHandler) : super(CekvesenetInitial()) {
    on<LoadCekVeSenet>(_onLoadCekler);
  }
  void _onLoadCekler(
      LoadCekVeSenet event, Emitter<CekvesenetState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(CekVeSenetLoading());
    try {
      final faturalar = await apiHandler.fetchCeks(
          prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '',
          event.raportur);

      emit(CekVeSenetLoadaed(Cekler: faturalar));
    } catch (e) {
      emit(CekVeSenetLoadFailure(error: e.toString()));
    }
  }
}
