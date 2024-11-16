import 'package:fitness_dashboard_ui/apihandler/model.dart';

abstract class DropdownState {}

class DropdownInitial extends DropdownState {}

class DropdownLoading extends DropdownState {}

class DropdownLoaded extends DropdownState {
  final List<Firma> firmas;
  final List<Donem> donems;
  final Firma? selectedFirma;
  final Donem? selectedDonem;
  final double? totalBakiye;
  final List<KasaDto>? kasalar;

  DropdownLoaded(this.firmas, this.donems, this.selectedFirma,
      this.selectedDonem, this.totalBakiye, this.kasalar);
}

class DropdownError extends DropdownState {
  final String message;
  DropdownError(this.message);
}
