import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/app_views.dart';
import '../../../auth/cubits/login_cubit/login_cubit.dart';
import '../../cubits/profile_cubit.dart';
import '../../cubits/profile_states.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is DeleteAccountFailureState) Alerts.showSnackBar(context, state.failure.message);
        if (state is DeleteAccountSuccessState) {
          Alerts.showToast(state.message);
          BlocProvider.of<LoginCubit>(context).logout();
          NavigationService.goBack(context);
        }
      },
      buildWhen: (prevState, state) => state is DeleteAccountLoadingState || prevState is DeleteAccountLoadingState,
      builder: (context, state) {
        return state is DeleteAccountLoadingState
            ? Padding(
                padding: EdgeInsetsDirectional.only(end: AppPadding.p16.w),
                child: const LoadingSpinner(),
              )
            : CustomTextButton(
                text: L10n.tr(context).deleteAccount,
                onPressed: () => Alerts.showAppDialog(
                  context,
                  title: L10n.tr(context).deleteAccountTitle,
                  description: L10n.tr(context).deleteAccountDesc,
                  onConfirm: () => BlocProvider.of<ProfileCubit>(context).deleteAccount(),
                  confirmText: L10n.tr(context).confirm,
                ),
                textColor: AppColors.red,
              );
      },
    );
  }
}
