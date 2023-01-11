import 'package:dartz/dartz.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:agar_online/core/services/error/failure.dart';
import 'package:agar_online/core/services/network/api_consumer.dart';
import 'package:agar_online/core/services/network/network_info.dart';
import 'package:agar_online/modules/auth/models/response/user_model.dart';
import '../../../core/services/error/error_handler.dart';
import '../../../core/services/local/cache_consumer.dart';
import '../../../core/services/local/storage_keys.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/notifications/notification_fcm.dart';
import '../../../core/utils/globals.dart';

class SocialAuthRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;
  final CacheConsumer _cacheConsumer;

  SocialAuthRepository(this._apiConsumer, this._networkInfo, this._cacheConsumer);

  Future<GoogleSignInAccount?> getGoogleAccount() async {
    await GoogleSignIn(clientId: clientId).signOut();
    GoogleSignInAccount? account = await GoogleSignIn(clientId: clientId).signIn();
    return account;
  }

  Future<Map<String, dynamic>> getFacebookAccount() async {
    await FacebookAuth.instance.logOut();
    await FacebookAuth.instance.login();
    final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData();
    return userData;
  }

  Future<Either<Failure, User>> googleSignIn(GoogleSignInAccount account) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(
          url: EndPoints.socialAuth,
          queryParameters: {
            "google_id": account.id,
            "first_name": account.displayName,
            "email": account.email,
            "avatar": account.photoUrl,
            "fcm_token": await NotificationsFCM.getToken(),
          },
        );
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

  Future<Either<Failure, User>> facebookSignIn(Map<String, dynamic> userData) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(
          url: EndPoints.socialAuth,
          queryParameters: {
            "facebook_id": userData["id"],
            "first_name": userData["name"],
            "email": userData["email"],
            "avatar": userData["picture"]["data"]["url"],
            "fcm_token": await NotificationsFCM.getToken(),
          },
        );
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
