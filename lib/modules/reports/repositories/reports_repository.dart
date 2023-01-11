import 'package:dartz/dartz.dart';

import 'package:agar_online/core/services/network/api_consumer.dart';
import 'package:agar_online/core/services/network/network_info.dart';
import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/endpoints.dart';
import '../models/body/report_ad_body.dart';

class ReportsRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  ReportsRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, String>> reportAd(ReportAdBody reportAdBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(url: EndPoints.reportAd, requestBody: reportAdBody.toFormData());
        if (response.data["data"] == null) throw Exception(ErrorType.unKnown.getFailure());
        return Right(L10n.tr(NavigationService.navigationKey.currentContext!).reportSentSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> reportUser(int userId, String message) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(
          url: EndPoints.reportUser,
          requestBody: {"user_id": userId, "message": message},
        );
        if (response.data["data"] == null) throw Exception(ErrorType.unKnown.getFailure());
        return Right(L10n.tr(NavigationService.navigationKey.currentContext!).reportSentSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
