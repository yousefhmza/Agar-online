import '../../../core/services/error/failure.dart';

abstract class HelpCenterStates {}

class HelpCenterInitialState extends HelpCenterStates {}

class SendHelpCenterMessageLoadingState extends HelpCenterStates {}

class SendHelpCenterMessageSuccessState extends HelpCenterStates {
  final String message;

  SendHelpCenterMessageSuccessState(this.message);
}

class SendHelpCenterMessageFailureState extends HelpCenterStates {
  final Failure failure;

  SendHelpCenterMessageFailureState(this.failure);
}
