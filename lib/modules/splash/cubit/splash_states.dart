import '../../../core/services/error/failure.dart';

abstract class SplashStates {}

class SplashInitialState extends SplashStates {}

class GetCurrentUserLoadingState extends SplashStates {}

class GetCurrentUserFailureState extends SplashStates {
  final Failure failure;

  GetCurrentUserFailureState(this.failure);
}

class GetCurrentUserSuccessState extends SplashStates {}
