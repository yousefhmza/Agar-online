import '../../../core/services/error/failure.dart';
import '../models/home_data_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeSetSliderIndexState extends HomeStates {}

class GetHomeDataLoadingState extends HomeStates {}

class GetHomeDataSuccessState extends HomeStates {}

class GetHomeDataFailureState extends HomeStates {
  final Failure failure;

  GetHomeDataFailureState(this.failure);
}
