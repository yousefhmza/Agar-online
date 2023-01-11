import 'dart:io';

import '../../../core/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_states.dart';
import '../models/body/profile_body.dart';
import '../repositories/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitialState());

  Future<void> editProfile(ProfileBody profileBody) async {
    emit(EditProfileLoadingState());
    final result = await _profileRepository.editProfile(profileBody);
    result.fold(
      (failure) => emit(EditProfileFailureState(failure)),
      (user) {
        currentUser = user;
        emit(EditProfileSuccessState());
      },
    );
  }

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    final result = await _profileRepository.deleteAccount();
    result.fold(
      (failure) => emit(DeleteAccountFailureState(failure)),
      (message) => emit(DeleteAccountSuccessState(message)),
    );
  }

  void pickProfileImage(ProfileBody profileBody, File image) {
    profileBody.copyWith(avatar: image);
    emit(SetProfileFieldValueState());
  }
}
