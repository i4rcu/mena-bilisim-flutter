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
  print('FetchHmalzeme event triggered');
  final prefs = await SharedPreferences.getInstance();
  emit(HmlazemeLoading());
  try {
    final faturalar = await apiHandler.HMalzemebilgileri(
      prefs.getString('selectedFirma') ?? '',
      prefs.getString('selectedDonem') ?? '',
    );
    print('Data fetched: $faturalar');  // Log fetched data
    emit(Hmalzemeloaded(faturalar));  // Ensure this state is being emitted
    print('State emitted: Hmalzemeloaded');  // Debugging log
  } catch (e) {
    emit(HmalzemeError(e.toString()));
    print('Error occurred: $e');  // Log error
  }
  
}
void _onLoadSatilanMalzeme(FetchSatilanMalzeme event, Emitter<MalzemelerState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  emit(SatilanmlazemeLoading());
  try {
    final faturalar = await apiHandler.SatilanMalzeme(
      prefs.getString('selectedFirma') ?? '',
      prefs.getString('selectedDonem') ?? '',
    );
    emit(Satilanmalzemeloaded(faturalar));  // Ensure this state is being emitted
    print('State emitted: Satilanmalzemeloaded');  // Debugging log
  } catch (e) {
    emit(SatilanmalzemeError(e.toString()));
    print('Error occurred: $e');  // Log error
  }

}

void _onLoadTumMalzeme(fetchTumMalzemeler event, Emitter<MalzemelerState> emit) async {
  print('FetchHmalzeme event triggered');
  final prefs = await SharedPreferences.getInstance();
  emit(TumMalzemeLoading());
  try {
    final faturalar = await apiHandler.TumMalzeme(
      prefs.getString('selectedFirma') ?? '',
      prefs.getString('selectedDonem') ?? '',
    );
    print('Data fetched: $faturalar');  // Log fetched data
    emit(TumMalzemeloaded(faturalar));  // Ensure this state is being emitted
    print('State emitted: Hmalzemeloaded');  // Debugging log
  } catch (e) {
    emit(TumMalzemeError(e.toString()));
    print('Error occurred: $e');  // Log error
  }
  

}
void _onLoadEnCokSatilanMalzemeler(fetchEnCokSatilanMalzemeler event, Emitter<MalzemelerState> emit) async {
  print('FetchEncokSatilanMalzemeler event triggered');
  final prefs = await SharedPreferences.getInstance();
  emit(EnCokSatilanMalzemeLoading());
  try {
    final faturalar = await apiHandler.fetchEnCokStailanMal(
      prefs.getString('selectedFirma') ?? '',
      prefs.getString('selectedDonem') ?? '',
      event.days
    );
    print('Data fetched: $faturalar');  // Log fetched data
    emit(EnCokSatilanMalzemeLoaded(faturalar));  // Ensure this state is being emitted
    print('State emitted: Hmalzemeloaded');  // Debugging log
  } catch (e) {
    emit(SatilanmalzemeError(e.toString()));
    print('Error occurred: $e');  // Log error
  }

}
void _onLoadGunlukMalzemeSatisi(fetchGunlukMalzemeSatisi event, Emitter<MalzemelerState> emit) async {
  print('FetchEncokSatilanMalzemeler event triggered');
  final prefs = await SharedPreferences.getInstance();
  emit(GunlukMalzemeSatisiLoading());
  try {
    final faturalar = await apiHandler.fetchGunlukMalzemeSatisi(
      prefs.getString('selectedFirma') ?? '',
      prefs.getString('selectedDonem') ?? '',
      event.days
    );
    print('Data fetched: $faturalar');  // Log fetched data
    emit(GunlukMalzemeSatisiLoaded(faturalar));  // Ensure this state is being emitted
    print('State emitted: Hmalzemeloaded');  // Debugging log
  } catch (e) {
    emit(GunlukMalzemeSatisiError(e.toString()));
    print('Error occurred: $e');  // Log error
  }

}
void _onLoadGunlukMalzemeAlisi(fetchGunlukMalzemeAlisi event, Emitter<MalzemelerState> emit) async {
  print('FetchEncokSatilanMalzemeler event triggered');
  final prefs = await SharedPreferences.getInstance();
  emit(GunlukMalzemeAlisiLoading());
  try {
    final faturalar = await apiHandler.fetchGunlukMalzemeAlisi(
      prefs.getString('selectedFirma') ?? '',
      prefs.getString('selectedDonem') ?? '',
      event.days
    );
    print('Data fetched: $faturalar');  // Log fetched data
    emit(GunlukMalzemeAlisiLoaded(faturalar));  // Ensure this state is being emitted
    print('State emitted: Hmalzemeloaded');  // Debugging log
  } catch (e) {
    emit(GunlukMalzemeAlisiError(e.toString()));
    print('Error occurred: $e');  // Log error
  }

}

}
