part of 'cari_hesap_bloc.dart';

@immutable
abstract class CariHesapState {}

class CariHesapInitial extends CariHesapState {}

class CariHesapLoading extends CariHesapState {}

class CariHesapDetailLoading extends CariHesapState {}

class CariHesapProcessDetailLoading extends CariHesapState {}

class CariHesapVirmanFisiDetailesLoaded extends CariHesapState {
  final List<VirmanFisi> virmanFisiDetails;
  CariHesapVirmanFisiDetailesLoaded(this.virmanFisiDetails);
}

class CariHesapBorcDekontuDetailesLoaded extends CariHesapState {
  final List<BorcDekontu> BorcDekontuDetails;
  CariHesapBorcDekontuDetailesLoaded(this.BorcDekontuDetails);
}

class CariHesapNakitTahsilatDetailesLoaded extends CariHesapState {
  final List<NakitTahsilat> NakitTahsilatDetails;
  CariHesapNakitTahsilatDetailesLoaded(this.NakitTahsilatDetails);
}

class CariHesapGelenHavaleDetailesLoaded extends CariHesapState {
  final List<GelenHavale> GelenHavaleDetails;
  CariHesapGelenHavaleDetailesLoaded(this.GelenHavaleDetails);
}

class CariHesapAlinanHizmetDetailesLoaded extends CariHesapState {
  final List<HizmetFaturasi> HizmetFaturasiDetails;
  CariHesapAlinanHizmetDetailesLoaded(this.HizmetFaturasiDetails);
}

class CariHesapCekVeSenetDetailesLoaded extends CariHesapState {
  final List<CekVeSenet> CekVeSenetDetails;
  CariHesapCekVeSenetDetailesLoaded(this.CekVeSenetDetails);
}

class CariHesapKrediKartDetailesLoaded extends CariHesapState {
  final List<KrediKarti> KrediKartiDetails;
  CariHesapKrediKartDetailesLoaded(this.KrediKartiDetails);
}

class CariHesapDefaultDetailesLoaded extends CariHesapState {
  final List<defaultCase> DefaultCaseDetails;
  CariHesapDefaultDetailesLoaded(this.DefaultCaseDetails);
}

class CariHesapLoaded extends CariHesapState {
  final List<CariHesap> cariHesaplar;

  CariHesapLoaded(this.cariHesaplar);
}

class CariHesapDetailesLoaded extends CariHesapState {
  final List<CariHesapDetail> cariHesapDetails;

  CariHesapDetailesLoaded(this.cariHesapDetails);
}

class CariHesapError extends CariHesapState {
  final String message;

  CariHesapError(this.message);
}
class EnCokSatilanCarilerLoading extends CariHesapState {}

class EnCokSatilanCarilerLoaded extends CariHesapState {
  final List<EnCokSatilanCariler> enCokSatilanCariler;

  EnCokSatilanCarilerLoaded(this.enCokSatilanCariler);
}