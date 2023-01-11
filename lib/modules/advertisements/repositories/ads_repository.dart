import 'package:agar_online/core/utils/helpers.dart';
import 'package:agar_online/modules/advertisements/models/body/filter_ads_body.dart';
import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import 'package:dartz/dartz.dart';

import '../../../core/services/error/failure.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/network_info.dart';
import '../models/response/advertisement_model.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/network/endpoints.dart';

class AdsRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  AdsRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, List<Advertisement>>> fetchFeaturedAds() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.featuredAds);
        return Right(Helpers.getNotBlockedAds(response.data["data"]["properties_features"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<Advertisement>>> fetchAdsBySubSubCategoryAndAdType(FilterAdsBody requestBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(
          url: EndPoints.getAdsBySubSubCategory,
          queryParameters: requestBody.toJson(),
        );
        return Right(Helpers.getNotBlockedAds(response.data["data"]["properties_features"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<Advertisement>>> fetchLatestAds() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getLatestAds);
        return Right(
          List<Advertisement>.from(Helpers.getNotBlockedAds(response.data["data"]["latest_properties"])),
        );
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, Advertisement>> fetchAdDetails(int id) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.fetchAdDetails, queryParameters: {"property_id": id});
        if (response.data["data"] == null) throw Exception(ErrorType.unKnown.getFailure());
        return Right(Advertisement.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<Advertisement>>> fetchMyAds() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getMyAds);
        if (response.data["data"] == null) throw Exception(ErrorType.unKnown.getFailure());
        return Right(List<Advertisement>.from(response.data["data"].map((ad) => Advertisement.fromJson(ad))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> deleteAd(int adId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(url: EndPoints.deleteAd, requestBody: {"property_id": adId});
        if (response.data["data"] == null) throw Exception(ErrorType.unKnown.getFailure());
        return Right(L10n.tr(NavigationService.navigationKey.currentContext!).deletedAdSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
