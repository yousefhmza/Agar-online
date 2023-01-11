import 'package:agar_online/core/services/error/failure.dart';
import 'package:agar_online/core/services/network/api_consumer.dart';
import 'package:agar_online/core/services/network/network_info.dart';
import 'package:dartz/dartz.dart';

import '../../../core/services/error/error_handler.dart';
import '../../../core/services/network/endpoints.dart';

class BlockRepository {
  final ApiConsumer apiConsumer;
  final NetworkInfo networkInfo;

  BlockRepository(this.apiConsumer, this.networkInfo);

  Future<Either<Failure, List<int>>> getBlockList() async {
    final bool hasConnection = await networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await apiConsumer.get(url: EndPoints.getBlockList);
        return Right(List<int>.from(response.data["data"].map((block) => block["block_user_id"])));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> blockUser(int userId) async {
    final bool hasConnection = await networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await apiConsumer.post(url: EndPoints.blockUser, requestBody: {"block_user_id": userId});
        return Right(response.data["message"]);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> unblockUser(int userId) async {
    final bool hasConnection = await networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await apiConsumer.post(url: EndPoints.unblockUser, requestBody: {"block_user_id": userId});
        return Right(response.data["message"]);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
