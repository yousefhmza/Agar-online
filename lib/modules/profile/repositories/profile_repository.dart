import 'package:dartz/dartz.dart';

import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/utils/globals.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/network/network_info.dart';
import '../../auth/models/response/user_model.dart';
import '../models/body/profile_body.dart';

class ProfileRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  ProfileRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, User>> editProfile(ProfileBody requestBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(url: EndPoints.editProfile, requestBody: await requestBody.toJson());
        return Right(User.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> deleteAccount() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        await _apiConsumer.post(url: EndPoints.deleteAccount, requestBody: {});
        // ignore: use_build_context_synchronously
        return Right(L10n.tr(globalContext).accountDeletedSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
