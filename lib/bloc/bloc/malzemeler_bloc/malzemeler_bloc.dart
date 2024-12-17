import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'malzemeler_event.dart';
part 'malzemeler_state.dart';

class MalzemelerBloc extends Bloc<MalzemelerEvent, MalzemelerState> {
  final ApiHandler apiHandler;

  MalzemelerBloc(this.apiHandler) : super(MalzemelerInitial()) {
    on<FetchHmalzeme>(_onLoadHMalzeme);
    on<FetchSatilanMalzeme>(_onLoadSatilanMalzeme);
     on<fetchTumMalzemeler>(_onLoadTumMalzeme);
     on<fetchEnCokSatilanMalzemeler>(_onLoadEnCokSatilanMalzemeler);
     on<fetchGunlukMalzemeSatisi>(_onLoadGunlukMalzemeSatisi);
     on<fetchGunlukMalzemeAlisi>(_onLoadGunlukMalzemeAlisi);
  }

  void _onLoadHMalzeme(FetchHmalzeme event, Emitter<MalzemelerState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  emit(HmlazemeLoading());
  try {
    final faturalar = await apiHandler.HMalzemebilgileri(
      prefs.getString('selectedFirma') ?? '001',
      prefs.getString('selectedDonem') ?? '01',
    );
    emit(Hmalzemeloaded(faturalar));  // Ensure this state is being emitted
  } catch (e) {
    emit(HmalzemeError(e.toString()));
  }
  
}
void _onLoadSatilanMalzeme(FetchSatilanMalzeme event, Emitter<MalzemelerState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  emit(SatilanmlazemeLoading());
  try {
    final faturalar = await apiHandler.SatilanMalzeme(
      prefs.getString('selectedFirma') ?? '001',
      prefs.getString('selectedDonem') ?? '01',
    );
    emit(Satilanmalzemeloaded(faturalar));  // Ensure this state is being emitted
  } catch (e) {
    emit(SatilanmalzemeError(e.toString()));
  }

}

void _onLoadTumMalzeme(fetchTumMalzemeler event, Emitter<MalzemelerState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  emit(TumMalzemeLoading());
  try {
    final faturalar = await apiHandler.TumMalzeme(
      prefs.getString('selectedFirma') ?? '001',
      prefs.getString('selectedDonem') ?? '01',
    );
    emit(TumMalzemeloaded(faturalar));  // Ensure this state is being emitted
  } catch (e) {
    emit(TumMalzemeError(e.toString()));
  }
  

}
void _onLoadEnCokSatilanMalzemeler(fetchEnCokSatilanMalzemeler event, Emitter<MalzemelerState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  emit(EnCokSatilanMalzemeLoading());
  try {
    final faturalar = await apiHandler.fetchEnCokStailanMal(
      prefs.getString('selectedFirma') ?? '001',
      prefs.getString('selectedDonem') ?? '01',
      event.days
    );
    emit(EnCokSatilanMalzemeLoaded(faturalar));  // Ensure this state is being emitted
  } catch (e) {
    emit(SatilanmalzemeError(e.toString()));
  }

}
void _onLoadGunlukMalzemeSatisi(fetchGunlukMalzemeSatisi event, Emitter<MalzemelerState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  emit(GunlukMalzemeSatisiLoading());
  try {
    final faturalar = await apiHandler.fetchGunlukMalzemeSatisi(
      prefs.getString('selectedFirma') ?? '001',
      prefs.getString('selectedDonem') ?? '01',
      event.days
    );
    emit(GunlukMalzemeSatisiLoaded(faturalar));  // Ensure this state is being emitted
  } catch (e) {
    emit(GunlukMalzemeSatisiError(e.toString()));
  }

}
void _onLoadGunlukMalzemeAlisi(fetchGunlukMalzemeAlisi event, Emitter<MalzemelerState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  emit(GunlukMalzemeAlisiLoading());
  try {
    final faturalar = await apiHandler.fetchGunlukMalzemeAlisi(
      prefs.getString('selectedFirma') ?? '001',
      prefs.getString('selectedDonem') ?? '01',
      event.days
    );
    emit(GunlukMalzemeAlisiLoaded(faturalar));  // Ensure this state is being emitted
  } catch (e) {
    emit(GunlukMalzemeAlisiError(e.toString()));
  }

}

}
