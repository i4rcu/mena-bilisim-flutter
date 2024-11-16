part of 'cari_hesap_bloc.dart';

@immutable
abstract class CariHesapEvent {}

class FetchCariHesaplar extends CariHesapEvent {
  final String tablePrefix;
  final String tableSuffix;

  FetchCariHesaplar(this.tablePrefix, this.tableSuffix);
}

class FetchCariHesapDetails extends CariHesapEvent {
  final String tablePrefix;
  final String tableSuffix;
  final int clientNo;
  FetchCariHesapDetails(this.tablePrefix, this.tableSuffix, this.clientNo);
}

class fetchCariHesapProcessDetails extends CariHesapEvent {
  final String? tablePrefix;
  final String? tableSuffix;
  final int? logicalref;
  final String? trcode;
  final int? invoice;
  final String? tranno;
  fetchCariHesapProcessDetails(this.tablePrefix, this.tableSuffix, this.trcode,
      this.invoice, this.tranno, this.logicalref);
}

class fetchEnCokSatilanCairler extends CariHesapEvent {
  final String? tablePrefix;
  final String? tableSuffix;
  final String? days;
  fetchEnCokSatilanCairler(this.tablePrefix, this.tableSuffix, this.days);
}