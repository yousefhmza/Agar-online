import 'package:agar_online/modules/advertisements/models/body/filter_ads_body.dart';
import 'package:agar_online/modules/reports/models/body/report_ad_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../categories/models/category_model.dart';
import '../../models/response/advertisement_model.dart';
import '../../repositories/ads_repository.dart';
import 'ads_states.dart';

class AdsCubit extends Cubit<AdsStates> {
  final AdsRepository _adsRepository;

  AdsCubit(this._adsRepository) : super(AdsInitialState());

  FilterAdsBody filterAdsBody = FilterAdsBody(); // used in sub sub category ads screen
  CategoryModel? selectedCategory; // used in featured ads
  List<Advertisement> allFeaturedAds = [];
  List<Advertisement> filteredAds = [];
  List<Advertisement> myAds = [];

  Future<void> fetchFeaturedAds() async {
    emit(GetFeaturedAdsLoadingState());
    final result = await _adsRepository.fetchFeaturedAds();
    result.fold(
      (failure) => emit(GetFeaturedAdsFailureState(failure)),
      (featuredAds) {
        allFeaturedAds = featuredAds;
        filteredAds = allFeaturedAds;
        emit(GetFeaturedAdsSuccessState());
      },
    );
  }

  Future<void> fetchLatestAds() async {
    emit(GetLatestAdsLoadingState());
    final result = await _adsRepository.fetchLatestAds();
    result.fold(
      (failure) => emit(GetLatestAdsFailureState(failure)),
      (latestAds) => emit(GetLatestAdsSuccessState(latestAds)),
    );
  }

  Future<void> fetchMyAds() async {
    emit(GetMyAdsLoadingState());
    final result = await _adsRepository.fetchMyAds();
    result.fold(
      (failure) => emit(GetMyAdsFailureState(failure)),
      (myAds) {
        this.myAds = myAds;
        emit(GetMyAdsSuccessState());
      },
    );
  }

  Future<void> deleteAd(int adId) async {
    emit(DeleteAdLoadingState(adId));
    final result = await _adsRepository.deleteAd(adId);
    result.fold(
      (failure) => emit(DeleteAdFailureState(failure, adId)),
      (message) {
        myAds.removeWhere((ad) => ad.id == adId);
        emit(DeleteAdSuccessState(message, adId));
      },
    );
  }

  void filterFeaturedAds(CategoryModel? category) {
    selectedCategory = category;
    filteredAds = selectedCategory == null
        ? allFeaturedAds
        : allFeaturedAds.where((ad) => ad.category.id == selectedCategory!.id).toList();
    emit(GetFeaturedAdsSuccessState());
  }

  Future<void> fetchAdDetails(int id) async {
    emit(GetAdDetailsLoadingState());
    final result = await _adsRepository.fetchAdDetails(id);
    result.fold(
      (failure) => emit(GetAdDetailsFailureState(failure)),
      (ad) => emit(GetAdDetailsSuccessState(ad)),
    );
  }

  Future<void> fetchAdsBySubSubCategoryAndAdType() async {
    emit(GetAdsBySubSubCategoryLoadingState());
    final result = await _adsRepository.fetchAdsBySubSubCategoryAndAdType(filterAdsBody);
    result.fold(
      (failure) => emit(GetAdsBySubSubCategoryFailureState(failure)),
      (ads) => emit(GetAdsBySubSubCategorySuccessState(ads)),
    );
  }


}
