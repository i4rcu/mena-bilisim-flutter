part of 'cekvesenet_bloc.dart';

@immutable
sealed class CekvesenetState {}

final class CekvesenetInitial extends CekvesenetState {}

final class CekVeSenetLoadaed extends CekvesenetState {
  final List<Cek> Cekler;
  CekVeSenetLoadaed({required this.Cekler});
}

final class CekVeSenetLoading extends CekvesenetState {}

final class CekVeSenetLoadFailure extends CekvesenetState {
  final String error;

  CekVeSenetLoadFailure({required this.error});
}
