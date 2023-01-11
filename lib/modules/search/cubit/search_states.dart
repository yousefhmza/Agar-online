import '../../../core/services/error/failure.dart';
import '../../advertisements/models/response/advertisement_model.dart';

abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class GetSearchLoadingState extends SearchStates {}

class GetSearchSuccessState extends SearchStates {
  final List<Advertisement> ads;

  GetSearchSuccessState(this.ads);
}

class GetSearchFailureState extends SearchStates {
  final Failure failure;

  GetSearchFailureState(this.failure);
}
