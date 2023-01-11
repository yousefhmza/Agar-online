import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/chat_cubit.dart';
import '../../cubits/chat_states.dart';
import '../widgets/message_bubble.dart';

class ChatBody extends StatelessWidget {
  final int adId;
  final int otherUserId;
  final ChatCubit chatCubit;
  final GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController;

  const ChatBody({
    required this.adId,
    required this.otherUserId,
    required this.chatCubit,
    required this.listKey,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listenWhen: (_, state) => state is GetChatHistorySuccessState,
      listener: (context, state) => Timer(
        Time.t50,
        () => scrollController.jumpTo(scrollController.position.maxScrollExtent),
      ),
      buildWhen: (_, state) =>
          state is GetChatHistorySuccessState ||
          state is GetChatHistoryFailureState ||
          state is GetChatHistoryLoadingState,
      builder: (context, state) {
        if (state is GetChatHistoryLoadingState) {
          return Center(child: CustomText(L10n.tr(context).loading, color: AppColors.grey));
        }
        if (state is GetChatHistoryFailureState) {
          return ErrorComponent(
            errorMessage: state.failure.message,
            onRetry: () => chatCubit.getChatHistory(chatCubit.currentChatId),
          );
        }
        return AnimatedList(
          key: listKey,
          padding: EdgeInsets.all(AppPadding.p16.w),
          controller: scrollController,
          initialItemCount: chatCubit.messages.length,
          itemBuilder: (context, index, animation) => SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: MessageBubble(
              text: chatCubit.messages[index].text,
              sentAt: chatCubit.messages[index].sentAt,
              sentByMe: chatCubit.messages[index].sentByMe,
            ),
          ),
        );
      },
    );
  }
}
