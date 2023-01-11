import 'package:agar_online/core/utils/globals.dart';
import 'package:dartz/dartz.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/local/cache_consumer.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/network/network_info.dart';
import '../models/body/login_body.dart';
import '../models/response/user_model.dart';

class LoginRepository {
  final ApiConsumer _apiConsumer;
  final CacheConsumer _cacheConsumer;
  final NetworkInfo _networkInfo;

  LoginRepository(this._apiConsumer, this._networkInfo, this._cacheConsumer);

  Future<Either<Failure, User>> login(LoginBody requestBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(url: EndPoints.login, requestBody: await requestBody.toJson());
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

  Future<Either<Failure, String>> sendNewPassword(String email) async {
    final hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        await _apiConsumer.get(url: EndPoints.forgetPassword, queryParameters: {"email": email});
        // ignore: use_build_context_synchronously
        return Right(L10n.tr(globalContext).sentNewPassword);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> logout() async {
    try {
      await _cacheConsumer.deleteSecuredData();
      await _cacheConsumer.delete(StorageKeys.isAuthed);
      return Right(L10n.tr(NavigationService.navigationKey.currentContext!).logoutSuccess);
    } on Exception catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
