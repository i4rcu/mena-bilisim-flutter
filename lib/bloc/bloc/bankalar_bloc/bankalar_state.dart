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
final class BankaDetaylarInitial extends BankalarState {}

class BankaDetaylarLoading extends BankalarState {}

class BankaDetaylarLoaded extends BankalarState {
  final List<BankaDetaylari> BankaDetaylar;
    final List<Banka> Bankalar;


  BankaDetaylarLoaded(this.BankaDetaylar,this.Bankalar);
}

class BankaDetaylarError extends BankalarState {
  final String message;

  BankaDetaylarError(this.message);
}