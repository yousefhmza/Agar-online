import '../../../core/services/error/failure.dart';

abstract class FavouritesStates {}

class FavouritesInitialState extends FavouritesStates {}

class GetFavouritesLoadingState extends FavouritesStates {}

class GetFavouritesSuccessState extends FavouritesStates {}

class GetFavouritesFailureState extends FavouritesStates {
  final Failure failure;

  GetFavouritesFailureState(this.failure);
}

class EditFavouriteLoadingState extends FavouritesStates {}

class EditFavouriteSuccessState extends FavouritesStates {}

class EditFavouriteFailureState extends FavouritesStates {
  final Failure failure;

  EditFavouriteFailureState(this.failure);
}
