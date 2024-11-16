import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'alinan_faturalar_event.dart';
part 'alinan_faturalar_state.dart';

class AlinanFaturalarBloc
    extends Bloc<AlinanFaturalarEvent, AlinanFaturalarState> {
  final ApiHandler apiHandler;
  AlinanFaturalarBloc(this.apiHandler) : super(AlinanFaturalarInitial()) {
    on<LoadAlinanFaturalar>(_onLoadAlinanFaturalar);
    on<LoadSatisFaturalar>(_onLoadSatisFaturalar);
    on<LoadFaturaDetay>(_onLoadFaturaDetay);
  }
  void _onLoadAlinanFaturalar(
      LoadAlinanFaturalar event, Emitter<AlinanFaturalarState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(AlinanFaturaLoading());
    try {
      final faturalar = await apiHandler.fetchAlinanFaturalar(
          prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '');

      emit(AlinanFaturalarLoadSuccess(faturalar));
    } catch (e) {
      emit(AlinanFaturaLoadFailure(error: e.toString()));
    }
  }

  void _onLoadSatisFaturalar(
      LoadSatisFaturalar event, Emitter<AlinanFaturalarState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(SatisFaturaLoading());
    try {
      final faturalar = await apiHandler.fetchSatisFaturalar(
          prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '');

      emit(SatisFaturalarLoadSuccess(faturalar));
    } catch (e) {
      emit(SatisFaturaLoadFailure(error: e.toString()));
    }
  }

  void _onLoadFaturaDetay(
      LoadFaturaDetay event, Emitter<AlinanFaturalarState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(FaturaDetayLoading());
    try {
      final faturalar = await apiHandler.fetchFaturaDetay(
          prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '',
          event.logicalref,
          event.tur);

      emit(FaturaDetayLoadSuccess(faturalar));
    } catch (e) {
      print(e);
      emit(FaturaDetayLoadFailure(error: e.toString() + "dsfsdfdf"));
    }
  }
}
