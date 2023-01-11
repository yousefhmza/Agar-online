import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/globals.dart';
import '../../models/body/signup_body.dart';
import '../../repositories/signup_repository.dart';
import 'signup_states.dart';

class SignupCubit extends Cubit<SignupStates> {
  final SignupRepository _signupRepository;

  SignupCubit(this._signupRepository) : super(SignupInitialState());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  List<int> interests = [];
  bool isPasswordVisible = false;
  bool agreedToTerms = false;
  final SignupBody signupBody = SignupBody(
    name: "",
    email: "",
    phone: "",
    password: "",
    passwordConfirmation: "",
    interests: [],
  );

  void setPasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(SetPasswordVisibilityState());
  }

  void setTermsAgreement(bool value) {
    agreedToTerms = value;
    emit(SetTermsAgreementState());
  }

  Future<void> signup() async {
    _assignSignupBody();
    FocusManager.instance.primaryFocus?.unfocus();
    emit(SignupLoadingState());
    final result = await _signupRepository.signup(signupBody);
    result.fold(
      (failure) => emit(SignupFailureState(failure)),
      (user) {
        resetControllers();
        currentUser = user;
        emit(SignupSuccessState());
      },
    );
  }

  void resetControllers() {
    phoneController.clear();
    passwordController.clear();
    nameController.clear();
    emailController.clear();
    confirmPasswordController.clear();
    interests.clear();
  }

  void _assignSignupBody() {
    signupBody.name = nameController.text.trim();
    signupBody.email = emailController.text.trim();
    signupBody.phone = phoneController.text.trim();
    signupBody.password = passwordController.text.trim();
    signupBody.passwordConfirmation = confirmPasswordController.text.trim();
    signupBody.interests = interests;
  }
}
