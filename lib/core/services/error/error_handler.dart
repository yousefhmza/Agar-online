import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorHandler {
  late Failure failure;

  ErrorHandler.handle(Exception error) {
    if (error is DioError) {
      failure = _handleDioError(error);
    } else {
      failure = ErrorType.unKnown.getFailure();
    }
  }

  Failure _handleDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.connectTimeout:
        return ErrorType.connectTimeOut.getFailure();
      case DioErrorType.sendTimeout:
        return ErrorType.sendTimeOut.getFailure();
      case DioErrorType.receiveTimeout:
        return ErrorType.receiveTimeOut.getFailure();
      case DioErrorType.response:
        {
          if (dioError.response?.statusMessage != null && dioError.response?.statusCode != null) {
            return Failure(dioError.response!.statusCode!, dioError.response!.data["message"]);
          } else {
            return ErrorType.unKnown.getFailure();
          }
        }
      case DioErrorType.cancel:
        return ErrorType.cancel.getFailure();
      case DioErrorType.other:
        return Failure(ResponseCode.unKnown, dioError.message);
    }
  }
}

enum ErrorType {
  cancel,
  connectTimeOut,
  receiveTimeOut,
  sendTimeOut,
  noInternetConnection,
  unKnown,
}

extension ErrorTypeException on ErrorType {
  Failure getFailure() {
    switch (this) {
      case ErrorType.connectTimeOut:
        return Failure(ResponseCode.connectTimeOut, ResponseMessage.connectTimeOut);
      case ErrorType.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case ErrorType.receiveTimeOut:
        return Failure(ResponseCode.receiveTimeOut, ResponseMessage.receiveTimeOut);
      case ErrorType.sendTimeOut:
        return Failure(ResponseCode.sendTimeOut, ResponseMessage.sendTimeOut);
      case ErrorType.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection, ResponseMessage.noInternetConnection);
      case ErrorType.unKnown:
        return Failure(ResponseCode.unKnown, ResponseMessage.unKnown);
    }
  }
}

class ResponseCode {
  static const int cancel = -1;
  static const int connectTimeOut = -2;
  static const int receiveTimeOut = -3;
  static const int sendTimeOut = -4;
  static const int noInternetConnection = -5;
  static const int unKnown = -6;
}

class ResponseMessage {
  static String cancel = L10n.tr(NavigationService.navigationKey.currentContext!).requestCancelled;
  static String connectTimeOut = L10n.tr(NavigationService.navigationKey.currentContext!).connectTimeOut;
  static String receiveTimeOut = L10n.tr(NavigationService.navigationKey.currentContext!).receiveTimeOut;
  static String sendTimeOut = L10n.tr(NavigationService.navigationKey.currentContext!).sendTimeOut;
  static String noInternetConnection = L10n.tr(NavigationService.navigationKey.currentContext!).noInternetConnection;
  static String unKnown = L10n.tr(NavigationService.navigationKey.currentContext!).unKnown;
}
