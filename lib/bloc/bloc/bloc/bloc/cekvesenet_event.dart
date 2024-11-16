part of 'cekvesenet_bloc.dart';

@immutable
sealed class CekvesenetEvent {}

class LoadCekVeSenet extends CekvesenetEvent {
  final String prefix;
  final String suffix;
  final String raportur;

  LoadCekVeSenet(
      {required this.prefix, required this.suffix, required this.raportur});
}
