import 'package:dartz/dartz.dart';

import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/network_info.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/endpoints.dart';
import '../models/city_area_model.dart';
import '../models/city_model.dart';
import '../models/sub_area_model.dart';

class RegionsRepository {
  final NetworkInfo _networkInfo;
  final ApiConsumer _apiConsumer;

  RegionsRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, List<City>>> getCities() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getCities);
        return Right(List<City>.from(response.data["data"].map((city) => City.fromJson(city))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<Area>>> getCityAreas(int cityId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getCityAreas, queryParameters: {"city_id": cityId});
        return Right(List<Area>.from(response.data["data"].map((area) => Area.fromJson(area))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<SubArea>>> getSubAreas(int areaId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getSubAreas, queryParameters: {"area_id": areaId});
        return Right(List<SubArea>.from(response.data["data"].map((cityArea) => SubArea.fromJson(cityArea))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
