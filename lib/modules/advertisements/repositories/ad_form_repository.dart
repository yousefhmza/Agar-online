import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import 'package:agar_online/modules/advertisements/models/response/setting_model.dart';
import '../models/body/edit_ad_body.dart';
import '../../../config/localization/l10n/l10n.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/network/network_info.dart';
import '../models/body/add_ad_body.dart';

class AdFormRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  AdFormRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, String>> addAd(BuildContext context, AddAdBody adBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(url: EndPoints.addAd, requestBody: await adBody.toFormData());
        if (response.data["data"] == null) throw Exception(ErrorType.unKnown.getFailure());
        // ignore: use_build_context_synchronously
        return Right(L10n.tr(context).adAddedSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> editAd(BuildContext context, EditAdBody editAdBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(
          url: EndPoints.editAd,
          requestBody: await editAdBody.toFormData(),
          queryParameters: {"property_id": editAdBody.id},
        );
        if (response.data["data"] == null) throw Exception(ErrorType.unKnown.getFailure());
        // ignore: use_build_context_synchronously
        return Right(L10n.tr(context).editedAdSuccessfully);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, String>> deleteAdImage(int imageId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        await _apiConsumer.post(url: EndPoints.deleteAdImage, requestBody: {"image_id": imageId});
        return const Right(Constants.empty);
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, SettingModel>> getSetting() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getSetting);
        return Right(SettingModel.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
