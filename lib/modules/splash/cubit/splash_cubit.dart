import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/globals.dart';
import '../repositories/splash_repository.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  final SplashRepository _splashRepository;

  SplashCubit(this._splashRepository) : super(SplashInitialState());

  bool get isAuthed => _splashRepository.isAuthed;

  Future<void> setTermsAgreed() async => await _splashRepository.setTermsAgreed();

  Future<void> getCurrentUser() async {
    emit(GetCurrentUserLoadingState());
    final result = await _splashRepository.getCurrentUser();
    result.fold(
      (failure) => emit(GetCurrentUserFailureState(failure)),
      (user) {
        currentUser = user;
        emit(GetCurrentUserSuccessState());
      },
    );
  }
}
