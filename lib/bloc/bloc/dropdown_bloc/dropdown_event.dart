import 'package:fitness_dashboard_ui/apihandler/model.dart';

abstract class DropdownEvent {}

class LoadDropdownData extends DropdownEvent {}

class SelectFirma extends DropdownEvent {
  final Firma selectedFirma;
  SelectFirma(this.selectedFirma);
}

class SelectDonem extends DropdownEvent {
  final Donem selectedDonem;
  SelectDonem(this.selectedDonem);
}

class UpdateSelectedValues extends DropdownEvent {
  final Firma selectedFirma;
  final Donem selectedDonem;
  UpdateSelectedValues(this.selectedFirma, this.selectedDonem);
}

class FetchKasaDetails extends DropdownEvent {
  final String tablePrefix;
  final String tableSuffix;

  FetchKasaDetails(this.tablePrefix, this.tableSuffix);
}
