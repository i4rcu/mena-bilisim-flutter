part of 'kasalar_bloc.dart';


@immutable
sealed class kasalarState {}

final class kasalarInitial extends kasalarState {}

class kasalarLoading extends kasalarState {}

class kasalarLoaded extends kasalarState {
  final List<KasaDto> kasalar;

  kasalarLoaded(this.kasalar);
}

class kasalarError extends kasalarState {
  final String message;

  kasalarError(this.message);
}



final class kasadetayInitial extends kasalarState {}

class kasadetayLoading extends kasalarState {}

class kasadetayLoaded extends kasalarState {
  final List<KasaDetaylar> kasadetaylar;
    final List<KasaDto> kasa;


  kasadetayLoaded(this.kasadetaylar,this.kasa);
}

class kasadetayError extends kasalarState {
  final String message;

  kasadetayError(this.message);
}





