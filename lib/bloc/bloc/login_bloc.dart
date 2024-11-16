import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/login_bloc/login_bloc.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_giris);
  }

  Future<void> _giris(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await ApiHandler().fetchUser(event.username, event.password);
      if (user == null) {
        emit(LoginFailure(error: 'Invalid username or password.'));
        return;
      }

      final license = await ApiHandler().fetchLicense(user.id);
      if (license == null) {
        emit(LoginFailure(error: 'No license found.'));
        return;
      }

      final now = DateTime.now();
      if (now.isAfter(license.licenseStartDate) &&
          now.isBefore(license.licenseEndDate)) {
        emit(LoginSuccess(userId: user.id,kullanici_vasfi: user.kullaniciVasfi));
      } else {
        emit(LoginFailure(error: 'License is not valid.'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'An error occurred. Please try again.'));
    }
  }
}
