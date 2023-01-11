import 'package:dartz/dartz.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/network_info.dart';
import '../../../core/utils/globals.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/endpoints.dart';
import '../../advertisements/models/response/advertisement_model.dart';

class FavouritesRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  FavouritesRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, List<Advertisement>>> fetchFavouriteAds() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getWishList);
        return Right(List<Advertisement>.from(
            response.data["data"].map((ad) => Advertisement.fromJson(ad))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> editFavouriteAd(int adId, bool add) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        await _apiConsumer.post(
          url: add ? EndPoints.addToFavourites : EndPoints.removeFromFavourites,
          requestBody: {"property_id": adId},
        );
        // ignore: use_build_context_synchronously
        return Right(L10n.tr(globalContext).editedAdSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
