part of 'alinan_faturalar_bloc.dart';

@immutable
sealed class AlinanFaturalarEvent {}

class LoadAlinanFaturalar extends AlinanFaturalarEvent {
  final String prefix;
  final String suffix;

  LoadAlinanFaturalar({required this.prefix, required this.suffix});
}

class LoadSatisFaturalar extends AlinanFaturalarEvent {
  final String prefix;
  final String suffix;

  LoadSatisFaturalar({required this.prefix, required this.suffix});
}

class LoadFaturaDetay extends AlinanFaturalarEvent {
  final String prefix;
  final String suffix;
  final int? logicalref;
  final int? tur;

  LoadFaturaDetay(
      {required this.prefix,
      required this.suffix,
      required this.logicalref,
      required this.tur});
}
class LoadAlinanAndSatisFaturalar extends AlinanFaturalarEvent {
  final String prefix;
  final String suffix;

  LoadAlinanAndSatisFaturalar({required this.prefix, required this.suffix});
}