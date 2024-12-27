part of 'kasalar_bloc.dart';

@immutable
sealed class kasalarEvent {}

class Fetchkasalar extends kasalarEvent {
  Fetchkasalar();
}

class Fetchkasadetaylari extends kasalarEvent {
  final int logicalref;
  Fetchkasadetaylari(this.logicalref);
}
