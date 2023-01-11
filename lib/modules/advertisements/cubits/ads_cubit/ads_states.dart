import '../../../../core/services/error/failure.dart';
import '../../models/response/advertisement_model.dart';

abstract class AdsStates {}

class AdsInitialState extends AdsStates {}

class SetSelectedChipState extends AdsStates {}

class GetFeaturedAdsLoadingState extends AdsStates {}

class GetFeaturedAdsSuccessState extends AdsStates {}

class GetFeaturedAdsFailureState extends AdsStates {
  final Failure failure;

  GetFeaturedAdsFailureState(this.failure);
}

class GetAdDetailsLoadingState extends AdsStates {}

class GetAdDetailsSuccessState extends AdsStates {
  final Advertisement ad;

  GetAdDetailsSuccessState(this.ad);
}

class GetAdDetailsFailureState extends AdsStates {
  final Failure failure;

  GetAdDetailsFailureState(this.failure);
}

class GetLatestAdsLoadingState extends AdsStates {}

class GetLatestAdsSuccessState extends AdsStates {
  final List<Advertisement> ads;

  GetLatestAdsSuccessState(this.ads);
}

class GetLatestAdsFailureState extends AdsStates {
  final Failure failure;

  GetLatestAdsFailureState(this.failure);
}

class GetAdsBySubSubCategoryLoadingState extends AdsStates {}

class GetAdsBySubSubCategorySuccessState extends AdsStates {
  final List<Advertisement> ads;

  GetAdsBySubSubCategorySuccessState(this.ads);
}

class GetAdsBySubSubCategoryFailureState extends AdsStates {
  final Failure failure;

  GetAdsBySubSubCategoryFailureState(this.failure);
}

class GetMyAdsLoadingState extends AdsStates {}

class GetMyAdsSuccessState extends AdsStates {}

class GetMyAdsFailureState extends AdsStates {
  final Failure failure;

  GetMyAdsFailureState(this.failure);
}

class DeleteAdLoadingState extends AdsStates {
  final int adId;

  DeleteAdLoadingState(this.adId);
}

class DeleteAdSuccessState extends AdsStates {
  final String message;
  final int adId;

  DeleteAdSuccessState(this.message, this.adId);
}

class DeleteAdFailureState extends AdsStates {
  final Failure failure;
  final int adId;

  DeleteAdFailureState(this.failure, this.adId);
}
