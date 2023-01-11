import 'package:dartz/dartz.dart';

import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/services/network/api_consumer.dart';
import 'package:agar_online/core/services/network/endpoints.dart';
import 'package:agar_online/core/services/network/network_info.dart';
import 'package:agar_online/core/utils/globals.dart';
import 'package:agar_online/modules/help_center/models/body/help_center_message_body.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';

class HelpCenterRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  HelpCenterRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, String>> sendHelpCenterMessage(HelpCenterMessageBody requestBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        await _apiConsumer.post(url: EndPoints.helpCenter, requestBody: requestBody.toJson());
        // ignore: use_build_context_synchronously
        return Right(L10n.tr(globalContext).messageReceivedSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
