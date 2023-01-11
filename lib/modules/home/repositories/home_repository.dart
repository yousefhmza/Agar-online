import 'package:dartz/dartz.dart';

import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/network/network_info.dart';
import '../models/home_data_model.dart';

class HomeRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  HomeRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, HomeData>> getHomeData() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getHomeData);
        return Right(HomeData.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
