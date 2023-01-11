import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/globals.dart';
import '../../models/body/login_body.dart';
import '../../repositories/login_repository.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginRepository loginRepository;

  LoginCubit(this.loginRepository) : super(LoginInitialState());

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final LoginBody loginBody = LoginBody(phone: "", password: "");

  void setPasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(SetPasswordVisibilityState());
  }

  Future<void> login() async {
    _assignLoginBody();
    FocusManager.instance.primaryFocus!.unfocus();
    emit(LoginLoadingState());
    final result = await loginRepository.login(loginBody);
    result.fold(
      (failure) => emit(LoginFailureState(failure)),
      (user) {
        resetControllers();
        currentUser = user;
        emit(LoginSuccessState());
      },
    );
  }

  Future<void> sendNewPassword(String email) async {
    emit(SendPasswordLoadingState());
    final result = await loginRepository.sendNewPassword(email);
    result.fold(
      (failure) => emit(SendPasswordFailureState(failure)),
      (message) => emit(SendPasswordSuccessState(message)),
    );
  }

  void _assignLoginBody() {
    loginBody.phone = phoneController.text.trim();
    loginBody.password = passwordController.text.trim();
  }

  void resetControllers() {
    phoneController.clear();
    passwordController.clear();
  }

  Future<void> logout() async {
    final result = await loginRepository.logout();
    result.fold(
      (failure) => emit(LogoutFailureState(failure)),
      (message) {
        currentUser = null;
        emit(LogoutSuccessState(message));
      },
    );
  }
}
