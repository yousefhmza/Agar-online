import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view/widgets/favourite_item.dart';
import '../../advertisements/models/response/advertisement_model.dart';
import '../repositories/favourites_repository.dart';
import 'favourites_states.dart';

class FavouritesCubit extends Cubit<FavouritesStates> {
  final FavouritesRepository _favouritesRepository;

  FavouritesCubit(this._favouritesRepository) : super(FavouritesInitialState());

  List<Advertisement>? favouriteAds;
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  Future<void> getFavouriteAds() async {
    emit(GetFavouritesLoadingState());
    final result = await _favouritesRepository.fetchFavouriteAds();
    result.fold(
      (failure) => emit(GetFavouritesFailureState(failure)),
      (favouriteAds) {
        this.favouriteAds = favouriteAds;
        emit(GetFavouritesSuccessState());
      },
    );
  }

  Future<void> editFavourite(Advertisement ad) async {
    ad.isFavourite = !ad.isFavourite;
    emit(EditFavouriteLoadingState());
    final result = await _favouritesRepository.editFavouriteAd(ad.id, ad.isFavourite);
    result.fold(
      (failure) {
        ad.isFavourite = !ad.isFavourite;
        emit(EditFavouriteFailureState(failure));
      },
      (message) {
        ad.isFavourite
            ? favouriteAds!.add(ad)
            : favouriteAds!.removeWhere((advertisement) => advertisement.id == ad.id);
        emit(EditFavouriteSuccessState());
      },
    );
  }

  Future<void> removeAdFromFavourites(int id) async {
    final int adIndex = favouriteAds!.indexWhere((ad) => ad.id == id);
    final Advertisement removedAd = favouriteAds!.removeAt(adIndex);
    animatedListKey.currentState!.removeItem(
      adIndex,
      (context, animation) => FavouriteItem(removedAd, animation: animation),
    );
    final result = await _favouritesRepository.editFavouriteAd(id, false);
    result.fold(
      (failure) {
        favouriteAds!.insert(adIndex, removedAd);
        animatedListKey.currentState!.insertItem(adIndex);
        emit(EditFavouriteFailureState(failure));
      },
      (message) => emit(EditFavouriteSuccessState()),
    );
  }
}
