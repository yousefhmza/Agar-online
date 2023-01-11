import 'package:dartz/dartz.dart';

import 'package:agar_online/modules/ad_type/model/ad_type_model.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/network_info.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/network/endpoints.dart';

class AdTypesRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  AdTypesRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, List<AdType>>> getAdTypes(int categoryId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(
          url: EndPoints.getAdTypes,
          queryParameters: {"category_id": categoryId},
        );
        return Right(List<AdType>.from(response.data["data"].map((adType) => AdType.fromJson(adType))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
