part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}
class FetchKullanicilar extends AdminEvent {
  FetchKullanicilar();
}
class UpdateKullanici extends AdminEvent {
  final int? id;
  final String? kullanici_ad;
  final String? sifre;
  final String? lisans_tarihi;
  final String? lisans_bitis_tarihi;
  final List<bool> checkboxes;
  final List<RaporYetkiler>? rapor_checkboxes;
  UpdateKullanici(this.id,this.kullanici_ad,this.sifre,this.lisans_tarihi,this.lisans_bitis_tarihi,this.checkboxes,this.rapor_checkboxes);
}

class UpdateRapor extends AdminEvent {
  final int? id;
  final String? rapor_adi;
  final String? rapor_sorgusu;

  UpdateRapor(this.id,this.rapor_adi,this.rapor_sorgusu);
}




class AddKullanici extends AdminEvent {
  final String? kullanici_ad;
  final String? sifre;
  final String? lisans_tarihi;
  final String? lisans_bitis_tarihi;
  final List<bool> checkboxes; 
  AddKullanici(this.kullanici_ad,this.sifre,this.lisans_tarihi,this.lisans_bitis_tarihi,this.checkboxes);
}




class FetchYetkiler extends AdminEvent {
 
  final int id; 
  FetchYetkiler(this.id);
}

class DeleteRapor extends AdminEvent {
  final int? kullanici_id;
  DeleteRapor(this.kullanici_id);
}


class DeleteKullanici extends AdminEvent {
  final int? kullanici_id;
  DeleteKullanici(this.kullanici_id);
}

class FetchRaporlar extends AdminEvent {
 FetchRaporlar();
}


class AddRapor extends AdminEvent {
  final String? raporAdi;
  final String? raporSorgusu;
  AddRapor(this.raporAdi,this.raporSorgusu);
}


class FetchKullaniciRaporlari extends AdminEvent {
  final int? id;
  FetchKullaniciRaporlari(this.id);
}
