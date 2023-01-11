import '../../../../core/services/error/failure.dart';

abstract class EditAdStates {}

class EditAdInitialState extends EditAdStates {}

class EditAdLoadingState extends EditAdStates {}

class EditAdSuccessState extends EditAdStates {
  final String message;

  EditAdSuccessState(this.message);
}

class EditAdFailureState extends EditAdStates {
  final Failure failure;

  EditAdFailureState(this.failure);
}

class DeleteAdImageLoadingState extends EditAdStates {
  final int imageId;

  DeleteAdImageLoadingState(this.imageId);
}

class DeleteAdImageSuccessState extends EditAdStates {}

class DeleteAdImageFailureState extends EditAdStates {
  final Failure failure;

  DeleteAdImageFailureState(this.failure);
}
