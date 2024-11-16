part of 'admin_bloc.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}
class KullanicilarLoading extends AdminState {}

class KullanicilarLoaded extends AdminState {
  final List<Kullanicilar> kullanicilar;

  KullanicilarLoaded(this.kullanicilar);
}

class KullanicilarError extends AdminState {
  final String message;

  KullanicilarError(this.message);
}


class KullaniciUpdating extends AdminState {}

class KullaniciUpdated extends AdminState {
  final bool isUpdated;
  KullaniciUpdated(this.isUpdated);
}

class KullaniciUpdateError extends AdminState {
  final String message;

  KullaniciUpdateError(this.message);
}

class RaporUpdating extends AdminState {}

class RaporUpdated extends AdminState {
  final bool isUpdated;
  RaporUpdated(this.isUpdated);
}

class RaporUpdateError extends AdminState {
  final String message;

  RaporUpdateError(this.message);
}


class KullaniciAdding extends AdminState {}

class KullaniciAdded extends AdminState {
  final bool isAdded;
  KullaniciAdded(this.isAdded);
}

class KullaniciAddError extends AdminState {
  final String message;

  KullaniciAddError(this.message);
}



class YetkilerFetching extends AdminState {}

class YetkilerFetched extends AdminState {
  final List<bool> checkboxes;
  final List<RaporYetkiler>rapor_checkboxes; 
  YetkilerFetched(this.checkboxes,this.rapor_checkboxes);
}

class YetkilerFetchingError extends AdminState {
  final String message;

  YetkilerFetchingError(this.message);
}




class KullaniciDeleting extends AdminState {}

class KullaniciDeleted extends AdminState {
  final bool isDeleted;
  KullaniciDeleted(this.isDeleted);
}

class KullaniciDeleteError extends AdminState {
  final String message;

  KullaniciDeleteError(this.message);
}




class RaporAdding extends AdminState {}

class RaporAdded extends AdminState {
  final bool isAdded;
  RaporAdded(this.isAdded);
}

class RaporAddError extends AdminState {
  final String message;

  RaporAddError(this.message);
}



class RaporlarFetching extends AdminState {}

class RaporlarFetched extends AdminState {
 final List<Raporlar> raporlar;
  RaporlarFetched(this.raporlar);
}

class RaporlarFetchingError extends AdminState {
  final String message;

  RaporlarFetchingError(this.message);
}


class RaporDeleting extends AdminState {}

class RaporDeleted extends AdminState {
  final bool isDeleted;
  RaporDeleted(this.isDeleted);
}

class RaporDeleteError extends AdminState {
  final String message;

  RaporDeleteError(this.message);
}

class KullaniciRaporFetching extends AdminState {}

class KullaniciRaporFetched extends AdminState {
final List<Raporlar> raporlar;
  KullaniciRaporFetched(this.raporlar);
}

class KullaniciRaporFetchError extends AdminState {
  final String message;

  KullaniciRaporFetchError(this.message);
}