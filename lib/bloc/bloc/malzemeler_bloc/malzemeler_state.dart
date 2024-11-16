part of 'malzemeler_bloc.dart';

@immutable
sealed class MalzemelerState {}

final class MalzemelerInitial extends MalzemelerState {}

class HmlazemeLoading extends MalzemelerState {}

class Hmalzemeloaded extends MalzemelerState {
  final List<HMalzeme> HMALZEMELER;

  Hmalzemeloaded(this.HMALZEMELER);
}

class HmalzemeError extends MalzemelerState {
  final String message;

  HmalzemeError(this.message);
}


class SatilanmlazemeLoading extends MalzemelerState {}

class Satilanmalzemeloaded extends MalzemelerState {
  final List<HangiMalzemeKimeSatildi> SATILANMALZEMELER;

  Satilanmalzemeloaded(this.SATILANMALZEMELER);
}

class SatilanmalzemeError extends MalzemelerState {
  final String message;

  SatilanmalzemeError(this.message);
}
class TumMalzemeLoading extends MalzemelerState {}

class TumMalzemeloaded extends MalzemelerState {
  final List<TumMalzemeler> TUMMALZEMELERR;

  TumMalzemeloaded(this.TUMMALZEMELERR);
}

class TumMalzemeError extends MalzemelerState {
  final String message;

  TumMalzemeError(this.message);
}

class EnCokSatilanMalzemeLoading extends MalzemelerState {}

class EnCokSatilanMalzemeLoaded extends MalzemelerState {
  final List<EnCokSatilanMalzeme> EnCokSatilanMalzemeler;

  EnCokSatilanMalzemeLoaded(this.EnCokSatilanMalzemeler);
}
class EnCokSatilanMalzemeError extends MalzemelerState {
  final String message;

  EnCokSatilanMalzemeError(this.message);
}

class GunlukMalzemeSatisiLoading extends MalzemelerState {}

class GunlukMalzemeSatisiLoaded extends MalzemelerState {
  final List<GunlukMalzemeSatisi> GunlukMalzemeSatisii;

  GunlukMalzemeSatisiLoaded(this.GunlukMalzemeSatisii);
}
class GunlukMalzemeSatisiError extends MalzemelerState {
  final String message;

  GunlukMalzemeSatisiError(this.message);
}

class GunlukMalzemeAlisiLoading extends MalzemelerState {}

class GunlukMalzemeAlisiLoaded extends MalzemelerState {
  final List<GunlukMalzemeAlisi> GunlukMalzemeAlisii;

  GunlukMalzemeAlisiLoaded(this.GunlukMalzemeAlisii);
}
class GunlukMalzemeAlisiError extends MalzemelerState {
  final String message;

  GunlukMalzemeAlisiError(this.message);
}