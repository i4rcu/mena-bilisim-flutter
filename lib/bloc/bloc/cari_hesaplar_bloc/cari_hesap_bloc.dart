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
          prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '',
          event.days);
          print(EnCokSatilancariHesaplar);
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
      print(prefs.getString('selectedFirma') ?? '');
      print(prefs.getString('selectedDonem') ?? '');
      final cariHesaplar = await apiHandler.fetchCariHesaplar(
          prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '');
          print(cariHesaplar);
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
      print(prefs.getString('selectedFirma') ?? '');
      print(prefs.getString('selectedDonem') ?? '');
      final cariHesapDetails = await apiHandler.fetchCariHesapDetails(
          prefs.getString('selectedFirma') ?? '',
          prefs.getString('selectedDonem') ?? '',
          event.clientNo);
      emit(CariHesapDetailesLoaded(cariHesapDetails));
    } catch (e) {
      emit(CariHesapError(e.toString() + "asdasd"));
      print(e);
    }
  }

  void _fetchprocess(
      fetchCariHesapProcessDetails event, Emitter<CariHesapState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(CariHesapDetailLoading());
    print(prefs.getString('selectedFirma') ?? '');
    print(prefs.getString('selectedDonem') ?? '');
    try {
      if (event.trcode == "Virman Fişi") {
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchVirmanFisiDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapVirmanFisiDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Borç Dekontu" ||
          event.trcode == "Alacak Dekontu") {
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchBorcDekontuDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapBorcDekontuDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Nakit Tahsilat" ||
          event.trcode == "Nakit Ödeme") {
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchNakitTahsilatDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);

        emit(CariHesapNakitTahsilatDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Gelen Havale" ||
          event.trcode == "Gönderilen Havale") {
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchGelenHavaleDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapGelenHavaleDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Alınan Hizmet Faturası" ||
          event.trcode == "Verilen Hizmet Faturası") {
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchHizmetFaturasiDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
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
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchCekDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapCekVeSenetDetailesLoaded(cariHesapDetails));
        return;
      } else if (event.trcode == "Kredi Kartı Fişi" ||
          event.trcode == "Firma Kredi Kartı Fişi") {
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchKrediKartDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapKrediKartDetailesLoaded(cariHesapDetails));
        return;
      } else {
        print("prefix: " + prefs.getString('selectedFirma')!);
        print("suffix: " + prefs.getString('selectedDonem')!);
        print("trcode: " + event.trcode!);
        print("invoice: " + event.invoice.toString());
        print("tranno: " + event.tranno!);
        print("logicalref: " + event.logicalref!.toString());
        final cariHesapDetails = await apiHandler.fetchdefaultDetails(
            prefs.getString('selectedFirma') ?? '',
            prefs.getString('selectedDonem') ?? '',
            event.trcode,
            event.invoice,
            event.tranno,
            event.logicalref);
        emit(CariHesapDefaultDetailesLoaded(cariHesapDetails));
        return;
      }
    } catch (e) {
      emit(CariHesapError(e.toString() + "asdasd"));
      print(e);
    }
  }
}
