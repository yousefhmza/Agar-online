import 'package:agar_online/modules/chat/cubits/chat_cubit.dart';
import 'package:agar_online/modules/chat/cubits/chat_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSend;

  const MessageTextField({required this.onSend, required this.messageController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w, vertical: AppPadding.p8.h),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              hintText: L10n.tr(context).typeYourMessage,
              minLines: 1,
              maxLines: 5,
              keyBoardType: TextInputType.multiline,
              controller: messageController,
            ),
          ),
          HorizontalSpace(AppSize.s16.w),
          BlocBuilder<ChatCubit, ChatStates>(
            builder: (context, state) {
              return InkWell(
                onTap: state is SendMessageLoadingState ? null : onSend,
                customBorder: const CircleBorder(),
                child: Ink(
                  padding: EdgeInsets.all(AppPadding.p12.w),
                  decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                  child: state is SendMessageLoadingState
                      ? const LoadingSpinner()
                      : const CustomIcon(Icons.send, color: AppColors.primaryRed),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
