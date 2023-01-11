import '../../../core/services/error/failure.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class SetProfileFieldValueState extends ProfileStates {}

class EditProfileLoadingState extends ProfileStates {}

class EditProfileSuccessState extends ProfileStates {}

class EditProfileFailureState extends ProfileStates {
  final Failure failure;

  EditProfileFailureState(this.failure);
}

class DeleteAccountLoadingState extends ProfileStates {}

class DeleteAccountSuccessState extends ProfileStates {
  final String message;

  DeleteAccountSuccessState(this.message);
}

class DeleteAccountFailureState extends ProfileStates {
  final Failure failure;

  DeleteAccountFailureState(this.failure);
}
