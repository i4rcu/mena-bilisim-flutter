part of 'bankalar_bloc.dart';

@immutable
sealed class BankalarState {}

final class BankalarInitial extends BankalarState {}

class BankalarLoading extends BankalarState {}

class BankalarLoaded extends BankalarState {
  final List<Banka> Bankalar;

  BankalarLoaded(this.Bankalar);
}

class BankalarError extends BankalarState {
  final String message;

  BankalarError(this.message);
}
