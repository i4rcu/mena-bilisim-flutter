part of 'malzemeler_bloc.dart';

@immutable
sealed class MalzemelerEvent {}
class FetchHmalzeme extends MalzemelerEvent {

  FetchHmalzeme();
}

class FetchSatilanMalzeme extends MalzemelerEvent {
 
  FetchSatilanMalzeme();
}

class fetchTumMalzemeler extends MalzemelerEvent {

  fetchTumMalzemeler();
}


class fetchEnCokSatilanMalzemeler extends MalzemelerEvent {
  final String? tablePrefix;
  final String? tableSuffix;
  final String? days;
  fetchEnCokSatilanMalzemeler(this.tablePrefix, this.tableSuffix, this.days);
}

class fetchGunlukMalzemeSatisi extends MalzemelerEvent {
  final String? tablePrefix;
  final String? tableSuffix;
  final String? days;
  fetchGunlukMalzemeSatisi(this.tablePrefix, this.tableSuffix, this.days);
}
class fetchGunlukMalzemeAlisi extends MalzemelerEvent {
  final String? tablePrefix;
  final String? tableSuffix;
  final String? days;
  fetchGunlukMalzemeAlisi(this.tablePrefix, this.tableSuffix, this.days);
}