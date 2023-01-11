import 'package:agar_online/core/services/error/failure.dart';
import 'package:agar_online/modules/chat/models/response/message_model.dart';

import '../models/response/chat_model.dart';

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class GetAllChatsLoadingState extends ChatStates {}

class GetAllChatsSuccessState extends ChatStates {
  final List<Chat> chats;

  GetAllChatsSuccessState(this.chats);
}

class GetAllChatsFailureState extends ChatStates {
  final Failure failure;

  GetAllChatsFailureState(this.failure);
}

class StartChatLoadingState extends ChatStates {}

class StartChatSuccessState extends ChatStates {}

class StartChatFailureState extends ChatStates {
  final Failure failure;

  StartChatFailureState(this.failure);
}

class GetChatHistoryLoadingState extends ChatStates {}

class GetChatHistorySuccessState extends ChatStates {}

class GetChatHistoryFailureState extends ChatStates {
  final Failure failure;

  GetChatHistoryFailureState(this.failure);
}

class SendMessageLoadingState extends ChatStates {}

class SendMessageSuccessState extends ChatStates {
  final Message message;

  SendMessageSuccessState(this.message);
}

class SendMessageFailureState extends ChatStates {
  final Failure failure;

  SendMessageFailureState(this.failure);
}
