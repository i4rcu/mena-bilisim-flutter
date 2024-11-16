part of 'alinan_faturalar_bloc.dart';

@immutable
sealed class AlinanFaturalarState {}

final class AlinanFaturalarInitial extends AlinanFaturalarState {}

class AlinanFaturaLoading extends AlinanFaturalarState {}

class AlinanFaturalarLoadSuccess extends AlinanFaturalarState {
  final List<AlinanFatura> Faturalar;

  AlinanFaturalarLoadSuccess(this.Faturalar);
}

class AlinanFaturaLoadFailure extends AlinanFaturalarState {
  final String error;

  AlinanFaturaLoadFailure({required this.error});
}

final class SatisFaturalarInitial extends AlinanFaturalarState {}

class SatisFaturaLoading extends AlinanFaturalarState {}

class SatisFaturalarLoadSuccess extends AlinanFaturalarState {
  final List<AlinanFatura> Faturalar;

  SatisFaturalarLoadSuccess(this.Faturalar);
}

class SatisFaturaLoadFailure extends AlinanFaturalarState {
  final String error;

  SatisFaturaLoadFailure({required this.error});
}

final class FaturaDetayInitial extends AlinanFaturalarState {}

class FaturaDetayLoading extends AlinanFaturalarState {}

class FaturaDetayLoadSuccess extends AlinanFaturalarState {
  final List<faturaDetay> Faturalar;

  FaturaDetayLoadSuccess(this.Faturalar);
}

class FaturaDetayLoadFailure extends AlinanFaturalarState {
  final String error;

  FaturaDetayLoadFailure({required this.error});
}
