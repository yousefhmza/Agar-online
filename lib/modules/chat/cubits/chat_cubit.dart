import 'package:agar_online/modules/chat/cubits/chat_states.dart';
import 'package:agar_online/modules/chat/models/body/message_body.dart';
import 'package:agar_online/modules/chat/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/response/message_model.dart';

class ChatCubit extends Cubit<ChatStates> {
  final ChatRepository _chatRepository;

  ChatCubit(this._chatRepository) : super(ChatInitialState());

  int currentChatId = 0;
  List<Message> messages = [];

  Future<void> getAllChats() async {
    emit(GetAllChatsLoadingState());
    final result = await _chatRepository.getAllChats();
    result.fold(
      (failure) => emit(GetAllChatsFailureState(failure)),
      (chats) => emit(GetAllChatsSuccessState(chats)),
    );
  }

  Future<void> initiateChat(int adId, int otherUserId) async {
    await startChat(adId, otherUserId);
    await getChatHistory(currentChatId);
  }

  Future<void> startChat(int adId, int toUserId) async {
    emit(StartChatLoadingState());
    final result = await _chatRepository.startChat(toUserId, adId);
    result.fold(
      (failure) => emit(StartChatFailureState(failure)),
      (chat) {
        currentChatId = chat.id;
        emit(StartChatSuccessState());
      },
    );
  }

  Future<void> getChatHistory(int chatId) async {
    emit(GetChatHistoryLoadingState());
    final result = await _chatRepository.getChatHistory(chatId);
    result.fold(
      (failure) => emit(GetChatHistoryFailureState(failure)),
      (messages) {
        this.messages = messages;
        emit(GetChatHistorySuccessState());
      },
    );
  }

  Future<void> sendMessage(MessageBody messageBody) async {
    emit(SendMessageLoadingState());
    final result = await _chatRepository.sendMessage(messageBody);
    result.fold(
      (failure) => emit(SendMessageFailureState(failure)),
      (message) => emit(SendMessageSuccessState(message)),
    );
  }
}
