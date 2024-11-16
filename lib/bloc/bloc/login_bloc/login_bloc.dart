import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_giris);
  }

  Future<void> _giris(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await ApiHandler().fetchUser(event.username, event.password);
      if (user == null) {
        emit(LoginFailure(error: 'Kullanıcı Adı Veya Şifre Hatalıdır.'));
        return;
      }

      final license = await ApiHandler().fetchLicense(user.id);
      if (license == null) {
        emit(LoginFailure(error: 'Lisansınız Bulunmamaktadır.'));
        return;
      }

      final now = DateTime.now();
      print(license.licenseEndDate);
      print(license.licenseStartDate);
      print(now);
if ((now.isAfter(license.licenseStartDate) || now.isAtSameMomentAs(license.licenseStartDate)) &&
    (now.isBefore(license.licenseEndDate) || now.isAtSameMomentAs(license.licenseEndDate))) {
  emit(LoginSuccess(userId: user.id, kullanici_vasfi: user.kullaniciVasfi));
}
 else {
        emit(LoginFailure(error: 'Lisansınız Geçerli Değildir.'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'An error occurred. Please try again.'));
    }
  }
}
