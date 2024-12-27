part of 'bankalar_bloc.dart';

@immutable
sealed class BankalarEvent {}

class FetchBankalar extends BankalarEvent {
  FetchBankalar();
}
class FetchBankaDetaylari extends BankalarEvent {
  final int logicalref;
  FetchBankaDetaylari(this.logicalref);
}