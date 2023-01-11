import 'package:dartz/dartz.dart';

import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_consumer.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/network/network_info.dart';
import '../../auth/models/response/user_model.dart';

class SplashRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;
  final CacheConsumer _cacheConsumer;

  SplashRepository(this._apiConsumer, this._networkInfo, this._cacheConsumer);

  bool get isAuthed => _cacheConsumer.get(StorageKeys.isAuthed) ?? false;

  Future<void> setTermsAgreed() async => await _cacheConsumer.save(StorageKeys.areTermsAgreed, true);

  Future<Either<Failure, User>> getCurrentUser() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getCurrentUser);
        return Right(User.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
