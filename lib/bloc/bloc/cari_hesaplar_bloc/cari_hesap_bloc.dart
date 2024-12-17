import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cari_hesap_event.dart';
part 'cari_hesap_state.dart';

class CariHesapBloc extends Bloc<CariHesapEvent, CariHesapState> {
  final ApiHandler apiHandler;

  CariHesapBloc(this.apiHandler) : super(CariHesapInitial()) {
    on<FetchCariHesaplar>(_onFetchCariHesaplar);
    on<FetchCariHesapDetails>(_onFetchCariHesapDetailes);
    on<fetchCariHesapProcessDetails>(_fetchprocess);
    on<fetchEnCokSatilanCairler>(_fetchEncokSatilanCairler);
  }

void _fetchEncokSatilanCairler(
      fetchEnCokSatilanCairler event, Emitter<CariHesapState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(EnCokSatilanCarilerLoading());
    try {
      final EnCokSatilancariHesaplar = await apiHandler.fetchEnCokSatilanCariHesaplar(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01',
          event.days);
      emit(EnCokSatilanCarilerLoaded(EnCokSatilancariHesaplar));
    } catch (e) {
      emit(CariHesapError(e.toString()));
    }
  }
  void _onFetchCariHesaplar(
      FetchCariHesaplar event, Emitter<CariHesapState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(CariHesapLoading());
    try {
     
      final cariHesaplar = await apiHandler.fetchCariHesaplar(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01');
      emit(CariHesapLoaded(cariHesaplar));
    } catch (e) {
      emit(CariHesapError(e.toString()));
    }
  }

  void _onFetchCariHesapDetailes(
      FetchCariHesapDetails event, Emitter<CariHesapState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(CariHesapLoading());
    try {
     
      final cariHesapDetails = await apiHandler.fetchCariHesapDetails(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01',
          event.clientNo);
       final cariHesaplar = await apiHandler.fetchCariHesaplar(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01');
      emit(CariHesapDetailesLoaded(cariHesapDetails,cariHesaplar));
    } catch (e) {
      emit(CariHesapError(e.toString() ));
    }
  }

  void _fetchprocess(
      fetchCariHesapProcessDetails event, Emitter<CariHesapState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(CariHesapDetailLoading());
   
    try {
      if (event.trcode == "Virman Fişi") {
  
        final cariHesapDetails = await apiHandler.fetchVirmanFisiDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapVirmanFisiDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Borç Dekontu" ||
          event.trcode == "Alacak Dekontu") {

        final cariHesapDetails = await apiHandler.fetchBorcDekontuDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapBorcDekontuDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Nakit Tahsilat" ||
          event.trcode == "Nakit Ödeme") {
        
        final cariHesapDetails = await apiHandler.fetchNakitTahsilatDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);

        emit(CariHesapNakitTahsilatDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Gelen Havale" ||
          event.trcode == "Gönderilen Havale") {
       
        final cariHesapDetails = await apiHandler.fetchGelenHavaleDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapGelenHavaleDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Alınan Hizmet Faturası" ||
          event.trcode == "Verilen Hizmet Faturası") {
       
        final cariHesapDetails = await apiHandler.fetchHizmetFaturasiDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapAlinanHizmetDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Çek Girişi" ||
          event.trcode == "Çek Çıkışı (Cari Hesaba)" ||
          event.trcode == "Senet Girişi" ||
          event.trcode == "Senet Çıkışı (Cari Hesaba)") {
       
        final cariHesapDetails = await apiHandler.fetchCekDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapCekVeSenetDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Kredi Kartı Fişi" ||
          event.trcode == "Firma Kredi Kartı Fişi") {
       
        final cariHesapDetails = await apiHandler.fetchKrediKartDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapKrediKartDetailesLoaded(cariHesapDetails));
        return;
      } else {
        
        final cariHesapDetails = await apiHandler.fetchdefaultDetails(
            prefs.getString('selectedFirma') ?? '001',
            prefs.getString('selectedDonem') ?? '01',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapDefaultDetailesLoaded(cariHesapDetails));
        return;
      }
    } catch (e) {
      emit(CariHesapError(e.toString() ));
    }
  }
}
