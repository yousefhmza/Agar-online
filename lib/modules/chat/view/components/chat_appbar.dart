import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../block/cubits/block_cubit.dart';
import '../../../block/cubits/block_states.dart';
import '../../cubits/chat_cubit.dart';
import '../../cubits/chat_states.dart';

class ChatAppbar extends StatelessWidget with PreferredSizeWidget {
  final String image;
  final String name;
  final int id;

  const ChatAppbar({required this.image, required this.name, required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      titleSpacing: AppSize.s0,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: AppSize.s8.w,
        leading: CircleAvatar(
          radius: AppSize.s24.r,
          backgroundColor: AppColors.white,
          backgroundImage: NetworkImage(image),
        ),
        title: CustomText(name),
      ),
      actions: [
        BlocBuilder<ChatCubit, ChatStates>(
          buildWhen: (prevState, state) =>
              state is StartChatLoadingState || state is StartChatFailureState || state is StartChatSuccessState,
          builder: (context, state) {
            return state is StartChatLoadingState || (state is StartChatFailureState && state.failure.statusCode == 402)
                ? const SizedBox.shrink()
                : BlocListener<BlockCubit, BlockStates>(
                    listener: (context, state) {
                      if (state is SetBlockLoadingState) Alerts.showLoadingDialog(context);
                      if (state is SetBlockFailureState) {
                        NavigationService.goBack(context);
                        Alerts.showSnackBar(context, state.failure.message);
                      }
                      if (state is SetBlockSuccessState) {
                        NavigationService.goBack(context);
                        NavigationService.goBack(context);
                        Alerts.showToast(state.message);
                      }
                    },
                    child: CustomIconButton(
                      icon: Icons.block,
                      color: AppColors.red,
                      onPressed: () => Alerts.showAppDialog(
                        context,
                        title: L10n.tr(context).blockUser,
                        onConfirm: () => BlocProvider.of<BlockCubit>(context).blockUser(id),
                        confirmText: L10n.tr(context).confirm,
                      ),
                    ),
                  );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
