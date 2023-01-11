import 'package:dartz/dartz.dart';

import '../models/body/signup_body.dart';
import '../models/response/user_model.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/network/network_info.dart';
import '../../../core/services/local/cache_consumer.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_consumer.dart';

class SignupRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;
  final CacheConsumer _cacheConsumer;

  SignupRepository(this._apiConsumer, this._networkInfo, this._cacheConsumer);

  Future<Either<Failure, User>> signup(SignupBody requestBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(url: EndPoints.signup, requestBody: await requestBody.toJson());
        await _cacheConsumer.saveSecuredData(StorageKeys.token, response.data["data"]["token"]);
        await _cacheConsumer.save(StorageKeys.isAuthed, true);
        return Right(User.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
