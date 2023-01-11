import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/core/view/app_views.dart';
import 'package:agar_online/modules/block/cubits/block_cubit.dart';
import 'package:agar_online/modules/block/cubits/block_states.dart';
import 'package:agar_online/modules/chat/cubits/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockedComponent extends StatefulWidget {
  final int adId;
  final int otherUserId;

  const BlockedComponent({required this.otherUserId, required this.adId, Key? key}) : super(key: key);

  @override
  State<BlockedComponent> createState() => _BlockedComponentState();
}

class _BlockedComponentState extends State<BlockedComponent> {
  late final BlockCubit blockCubit;

  @override
  void initState() {
    blockCubit = BlocProvider.of<BlockCubit>(context);
    blockCubit.getBlockList();
    super.initState();
  }

  @override
  void dispose() {
    blockCubit.blockedUsersIds.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomIcon(Icons.report_problem_outlined, color: AppColors.grey, size: AppSize.s72),
          VerticalSpace(AppSize.s8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
            child: CustomText(L10n.tr(context).mutualBlock, textAlign: TextAlign.center),
          ),
          VerticalSpace(AppSize.s8.h),
          BlocBuilder<BlockCubit, BlockStates>(
            builder: (context, state) {
              return blockCubit.blockedUsersIds.contains(widget.otherUserId)
                  ? BlocConsumer<BlockCubit, BlockStates>(
                      listener: (context, state) {
                        if (state is SetBlockSuccessState) {
                          BlocProvider.of<ChatCubit>(context).initiateChat(widget.adId, widget.otherUserId);
                        }
                        if (state is SetBlockFailureState) {
                          Alerts.showActionSnackBar(
                            context,
                            message: state.failure.message,
                            actionLabel: L10n.tr(context).retry,
                            onActionPressed: () => BlocProvider.of<BlockCubit>(context).unblockUser(widget.otherUserId),
                          );
                        }
                      },
                      builder: (context, state) => state is SetBlockLoadingState
                          ? const LoadingSpinner()
                          : CustomTextButton(
                              text: L10n.tr(context).unblock,
                              onPressed: () => BlocProvider.of<BlockCubit>(context).unblockUser(widget.otherUserId),
                            ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
