import 'package:dartz/dartz.dart';

import '../models/body/search_params_body.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/network_info.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/endpoints.dart';
import '../../advertisements/models/response/advertisement_model.dart';

class SearchRepository {
  final NetworkInfo _networkInfo;
  final ApiConsumer _apiConsumer;

  SearchRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, List<Advertisement>>> getSearch(SearchParamsBody searchParamsBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getSearch, queryParameters: searchParamsBody.toJson());
        return Right(List<Advertisement>.from(response.data["data"].map((ad) => Advertisement.fromJson(ad))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
