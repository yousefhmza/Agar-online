import 'package:agar_online/core/utils/globals.dart';
import 'package:agar_online/modules/auth/cubits/social_auth_cubit/social_auth_states.dart';
import 'package:agar_online/modules/auth/repositories/social_auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialAuthCubit extends Cubit<SocialAuthStates> {
  final SocialAuthRepository _socialAuthRepository;

  SocialAuthCubit(this._socialAuthRepository) : super(SocialAuthInitialState());

  Future<void> googleSignIn() async {
    final account = await _socialAuthRepository.getGoogleAccount();
    if (account == null) return;
    emit(SocialAuthLoadingState());
    final result = await _socialAuthRepository.googleSignIn(account);
    result.fold(
      (failure) => emit(SocialAuthFailureState(failure)),
      (user) {
        currentUser = user;
        emit(SocialAuthSuccessState());
      },
    );
  }

  Future<void> facebookSignIn() async {
    final userData = await _socialAuthRepository.getFacebookAccount();
    print(userData);
    emit(SocialAuthLoadingState());
    final result = await _socialAuthRepository.facebookSignIn(userData);
    result.fold(
      (failure) => emit(SocialAuthFailureState(failure)),
      (user) {
        currentUser = user;
        emit(SocialAuthSuccessState());
      },
    );
  }
}
