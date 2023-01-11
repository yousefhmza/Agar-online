import '../../../../core/services/error/failure.dart';

abstract class SocialAuthStates {}

class SocialAuthInitialState extends SocialAuthStates {}

class SocialAuthLoadingState extends SocialAuthStates {}

class SocialAuthSuccessState extends SocialAuthStates {}

class SocialAuthFailureState extends SocialAuthStates {
  final Failure failure;

  SocialAuthFailureState(this.failure);
}
