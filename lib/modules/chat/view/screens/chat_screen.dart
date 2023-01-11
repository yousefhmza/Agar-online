import 'package:agar_online/modules/chat/view/components/blocked_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/modules/chat/view/components/chat_body.dart';
import 'package:agar_online/modules/chat/models/body/message_body.dart';
import 'package:agar_online/core/view/app_views.dart';
import 'package:agar_online/modules/chat/cubits/chat_cubit.dart';
import 'package:agar_online/modules/chat/cubits/chat_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../components/chat_appbar.dart';
import '../components/message_text_field.dart';

class ChatScreen extends StatefulWidget {
  final int otherUserId;
  final String otherUserName;
  final String otherUserImage;
  final int adId;

  const ChatScreen({
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImage,
    required this.adId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatCubit chatCubit;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    chatCubit = BlocProvider.of<ChatCubit>(context);
    chatCubit.initiateChat(widget.adId, widget.otherUserId);
    super.initState();
  }

  @override
  void dispose() {
    chatCubit.messages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppbar(image: widget.otherUserImage, name: widget.otherUserName, id: widget.otherUserId),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatStates>(
              buildWhen: (prevState, state) =>
                  state is StartChatLoadingState || state is StartChatFailureState || state is StartChatSuccessState,
              builder: (context, state) {
                if (state is StartChatLoadingState) return const LoadingSpinner();
                if (state is StartChatFailureState && state.failure.statusCode != 402) {
                  return ErrorComponent(
                    errorMessage: state.failure.message,
                    onRetry: () => chatCubit.startChat(widget.adId, widget.otherUserId),
                  );
                }
                if (state is StartChatFailureState && state.failure.statusCode == 402) {
                  return BlockedComponent(otherUserId: widget.otherUserId, adId: widget.adId);
                }
                return ChatBody(
                  adId: widget.adId,
                  otherUserId: widget.otherUserId,
                  scrollController: scrollController,
                  chatCubit: chatCubit,
                  listKey: listKey,
                );
              },
            ),
          ),
          BlocConsumer<ChatCubit, ChatStates>(
            listener: (context, state) {
              if (state is SendMessageSuccessState) {
                chatCubit.messages.add(state.message);
                listKey.currentState!.insertItem(chatCubit.messages.length - 1, duration: Time.t300);
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent + AppSize.s100.h,
                  duration: Time.t300,
                  curve: Curves.easeInOut,
                );
                messageController.clear();
              }
              if (state is SendMessageFailureState) {
                Alerts.showActionSnackBar(
                  context,
                  message: state.failure.message,
                  actionLabel: L10n.tr(context).retry,
                  onActionPressed: () => chatCubit.sendMessage(
                    MessageBody(
                      propertyId: widget.adId,
                      message: messageController.text.trim(),
                      toUserId: widget.otherUserId,
                      chatId: chatCubit.currentChatId,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) => MessageTextField(
              onSend: () {
                if (messageController.text.trim().isNotEmpty) {
                  chatCubit.sendMessage(
                    MessageBody(
                      propertyId: widget.adId,
                      message: messageController.text.trim(),
                      toUserId: widget.otherUserId,
                      chatId: chatCubit.currentChatId,
                    ),
                  );
                }
              },
              messageController: messageController,
            ),
          ),
        ],
      ),
    );
  }
}
