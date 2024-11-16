part of 'bankalar_bloc.dart';

@immutable
sealed class BankalarEvent {}

class FetchBankalar extends BankalarEvent {
  FetchBankalar();
}
