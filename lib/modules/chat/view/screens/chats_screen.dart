import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/modules/chat/cubits/chat_states.dart';
import 'package:agar_online/modules/chat/view/widgets/chat_tile.dart';
import 'package:agar_online/modules/chat/cubits/chat_cubit.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/view/components/empty_component.dart';
import '../../../splash/cubit/splash_cubit.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late final ChatCubit chatCubit;

  @override
  void initState() {
    chatCubit = BlocProvider.of<ChatCubit>(context);
    if (BlocProvider.of<SplashCubit>(context).isAuthed) chatCubit.getAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.of<SplashCubit>(context).isAuthed
        ? Column(
            children: [
              CustomAppbar(
                hasTitleSpacing: true,
                title: CustomText(L10n.tr(context).chats, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
              ),
              Expanded(
                child: BlocBuilder<ChatCubit, ChatStates>(
                  buildWhen: (_, state) =>
                      state is GetAllChatsSuccessState ||
                      state is GetAllChatsFailureState ||
                      state is GetAllChatsLoadingState,
                  builder: (context, state) {
                    if (state is GetAllChatsSuccessState) {
                      return state.chats.isEmpty
                          ? EmptyComponent(text: L10n.tr(context).noChatsYet)
                          : CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => Column(
                                        children: [
                                          ChatTile(state.chats[index]),
                                          if (index != state.chats.length - 1) const Divider(),
                                        ],
                                      ),
                                      childCount: state.chats.length,
                                    ),
                                  ),
                                ),
                                VerticalSpace.sliver(AppSize.s100.h),
                              ],
                            );
                    }
                    if (state is GetAllChatsFailureState) {
                      return ErrorComponent(
                        errorMessage: state.failure.message,
                        onRetry: () => chatCubit.getAllChats(),
                      );
                    }
                    return const LoadingSpinner();
                  },
                ),
              ),
            ],
          )
        : const NotLoggedInWidget();
  }
}
