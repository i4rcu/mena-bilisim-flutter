import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bankalar_event.dart';
part 'bankalar_state.dart';

class BankalarBloc extends Bloc<BankalarEvent, BankalarState> {
  final ApiHandler apiHandler;
  BankalarBloc(this.apiHandler) : super(BankalarInitial()) {
    on<FetchBankalar>(_onFetchBankalar);
  }

  void _onFetchBankalar(
      FetchBankalar event, Emitter<BankalarState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(BankalarLoading());
    try {
      final cariHesaplar = await apiHandler.fetchBankaHesapDetails(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01');
      emit(BankalarLoaded(cariHesaplar));
    } catch (e) {
      emit(BankalarError(e.toString()));
    }
  }
}
