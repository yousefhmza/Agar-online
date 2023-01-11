import 'package:agar_online/modules/chat/models/body/message_body.dart';
import 'package:agar_online/modules/chat/models/response/message_model.dart';
import 'package:dartz/dartz.dart';

import 'package:agar_online/core/services/error/error_handler.dart';
import 'package:agar_online/core/services/error/failure.dart';
import 'package:agar_online/core/services/network/api_consumer.dart';
import 'package:agar_online/core/services/network/endpoints.dart';
import 'package:agar_online/core/services/network/network_info.dart';
import 'package:agar_online/modules/chat/models/response/chat_model.dart';

class ChatRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  ChatRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, List<Chat>>> getAllChats() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getAllChats);
        return Right(List<Chat>.from(response.data["data"].map((chat) => Chat.fromJson(chat))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, Chat>> startChat(int toUserId, int adId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(
          url: EndPoints.startChat,
          requestBody: {"property_id": adId, "to_user_id": toUserId},
        );
        return Right(Chat.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<Message>>> getChatHistory(int chatId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(
          url: EndPoints.getChatHistory,
          queryParameters: {"chat_id": chatId},
        );
        return Right(List<Message>.from(response.data["data"][0]["children"].map((chat) => Message.fromJson(chat))));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, Message>> sendMessage(MessageBody messageBody) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.post(
          url: EndPoints.sendMessage,
          requestBody: messageBody.toJson(),
        );
        return Right(Message.fromJson(response.data["data"]));
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
