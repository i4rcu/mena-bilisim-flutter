
import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/UserSession.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
    
    final ApiHandler apiHandler;

    
  AdminBloc(this.apiHandler) : super(AdminInitial()) {
    on<FetchKullanicilar>(_onLoadKullanicilar);
    on<AddKullanici>(_onAddKullanici);
    on<UpdateKullanici>(_onUpdateKullanici);
    on<DeleteKullanici>(_onDeleteKullanici);
    on<FetchYetkiler>(_onFetchYetkiler);
    on<FetchRaporlar>(_onFetchRaporlar);
    on<UpdateRapor>(_onUpdateRapor);
    on<DeleteRapor>(_onDeleteRapor);
    on<AddRapor>(_onAddRapor);
    on<FetchKullaniciRaporlari>(_onFetchKullaniciRaporlar);
    

  } 
  
  void _onFetchKullaniciRaporlar(
      FetchKullaniciRaporlari event, Emitter<AdminState> emit) async {
    emit(KullaniciRaporFetching());
    try {
      final faturalar = await apiHandler.KullaniciRaporlari(UserSession().userId!);
      emit(KullaniciRaporFetched(faturalar));
    } catch (e) {
      emit(KullaniciRaporFetchError(e.toString()));
    }
  }
  void _onFetchRaporlar(
      FetchRaporlar event, Emitter<AdminState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(RaporlarFetching());
    try {
      final faturalar = await apiHandler.TumRaporlar(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01');
      emit(RaporlarFetched(faturalar));
    } catch (e) {
      emit(RaporlarFetchingError(e.toString()));
    }
  }
  void _onFetchYetkiler(
      FetchYetkiler event, Emitter<AdminState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(YetkilerFetching());
    try {
      final faturalar = await apiHandler.Yetkiler(
          prefs.getString('selectedFirma') ?? '001',
          event.id);
      final raporlar = await apiHandler.RaporYetkileri(event.id);
      emit(YetkilerFetched(faturalar,raporlar));
    } catch (e) {
      emit(YetkilerFetchingError(e.toString()));
    }
  }
  void _onLoadKullanicilar(
      FetchKullanicilar event, Emitter<AdminState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(KullanicilarLoading());
    try {
      final faturalar = await apiHandler.Tumkullanicilar(
          prefs.getString('selectedFirma') ?? '001',
          prefs.getString('selectedDonem') ?? '01');
      emit(KullanicilarLoaded(faturalar));
    } catch (e) {
      emit(KullanicilarError(e.toString()));
    }
  }
   void _onUpdateKullanici(UpdateKullanici event, Emitter<AdminState> emit) async {
  emit(KullaniciUpdating()); // Indicate that updating has started

  try {
      bool isUpdated = await apiHandler.UpdateUser(
      event.id!,
      event.kullanici_ad!,
      event.sifre!,
      event.lisans_tarihi!,
      event.lisans_bitis_tarihi!,
      event.checkboxes,
      event.rapor_checkboxes!
      
      
    );

    if (isUpdated) {
      emit(KullaniciUpdated(true));
    } else {
      emit(KullaniciUpdateError("Failed to update user."));
    }
  } catch (e) {
    emit(KullaniciUpdateError(e.toString()));
  }
}
void _onUpdateRapor(UpdateRapor event, Emitter<AdminState> emit) async {
  emit(RaporUpdating()); // Indicate that updating has started

  try {
      bool isUpdated = await apiHandler.UpdateRapor(
      event.id!,
      event.rapor_adi!,
      event.rapor_sorgusu!,

    );

    if (isUpdated) {
      emit(KullaniciUpdated(true));
    } else {
      emit(KullaniciUpdateError("Failed to update user."));
    }
  } catch (e) {
    emit(KullaniciUpdateError(e.toString()));
  }
}
void _onDeleteKullanici(DeleteKullanici event, Emitter<AdminState> emit) async {
  emit(KullaniciDeleting()); // Indicate that updating has started

  try {
      bool isDeleted = await apiHandler.DeleteUser(
      event.kullanici_id!,
    );

    if (isDeleted) {
      emit(KullaniciDeleted(true));
    } else {
      emit(KullaniciDeleteError("Failed to update user."));
    }
  } catch (e) {
    emit(KullaniciDeleteError(e.toString()));
  }
}
void _onDeleteRapor(DeleteRapor event, Emitter<AdminState> emit) async {
  emit(RaporDeleting()); // Indicate that updating has started

  try {
      bool isDeleted = await apiHandler.DeleteRapor(
      event.kullanici_id!,
      
    );

    if (isDeleted) {
      emit(RaporDeleted(true));
    } else {
      emit(RaporDeleteError("Failed to update user."));
    }
  } catch (e) {
    emit(RaporDeleteError(e.toString()));
  }
}



void _onAddKullanici(AddKullanici event, Emitter<AdminState> emit) async {
  emit(KullaniciAdding()); 
  try {

    // Update user details
      apiHandler.AddUser(
      event.kullanici_ad!,
      event.sifre!,
      event.lisans_tarihi!,
      event.lisans_bitis_tarihi!,

      event.checkboxes
    );
      emit(KullaniciAdded(true));
  } catch (e) {
    emit(KullaniciAddError(e.toString()));
  }
}

void _onAddRapor(AddRapor event, Emitter<AdminState> emit) async {
  emit(RaporAdding()); 
  try {

    // Update user details
      apiHandler.AddRapor(
        event.raporAdi!,
        event.raporSorgusu!
    );
      emit(RaporAdded(true));
  } catch (e) {
    emit(RaporAddError(e.toString()));
  }
}

}
