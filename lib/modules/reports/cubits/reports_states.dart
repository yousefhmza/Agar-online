import '../../../core/services/error/failure.dart';

abstract class ReportsStates {}

class ReportsInitialState extends ReportsStates {}

class ReportLoadingState extends ReportsStates {}

class ReportSuccessState extends ReportsStates {
  final String message;

  ReportSuccessState(this.message);
}

class ReportFailureState extends ReportsStates {
  final Failure failure;

  ReportFailureState(this.failure);
}
