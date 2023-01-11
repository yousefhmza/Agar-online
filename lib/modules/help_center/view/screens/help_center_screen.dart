import 'package:agar_online/config/routing/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/core/utils/validators.dart';
import 'package:agar_online/modules/help_center/cubits/help_center_states.dart';
import '../../../../config/localization/l10n/l10n.dart';
import 'package:agar_online/modules/help_center/cubits/help_center_cubit.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class HelpCenterScreen extends StatelessWidget {
  HelpCenterScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final HelpCenterCubit helpCenterCubit = BlocProvider.of<HelpCenterCubit>(context);
    helpCenterCubit.helpCenterMessageBody.resetValues();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        title: CustomText(L10n.tr(context).helpCenter, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hintText: L10n.tr(context).name,
                  keyBoardType: TextInputType.name,
                  validator: Validators.notEmptyValidator,
                  onChanged: (value) => helpCenterCubit.helpCenterMessageBody.copyWith(name: value),
                  prefix: const CustomIcon(Icons.person),
                ),
                VerticalSpace(AppSize.s24.h),
                CustomTextField(
                  hintText: L10n.tr(context).enterMessageText,
                  maxLines: 5,
                  minLines: 5,
                  keyBoardType: TextInputType.text,
                  validator: Validators.notEmptyValidator,
                  onChanged: (value) => helpCenterCubit.helpCenterMessageBody.copyWith(message: value),
                ),
                VerticalSpace(AppSize.s32.h),
                BlocConsumer<HelpCenterCubit, HelpCenterStates>(
                  listener: (context, state) {
                    if (state is SendHelpCenterMessageFailureState) Alerts.showSnackBar(context, state.failure.message);
                    if (state is SendHelpCenterMessageSuccessState) {
                      Alerts.showToast(state.message);
                      NavigationService.goBack(context);
                    }
                  },
                  builder: (context, state) => state is SendHelpCenterMessageLoadingState
                      ? const LoadingSpinner()
                      : CustomButton(
                          width: double.infinity,
                          text: L10n.tr(context).send,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) helpCenterCubit.sendHelpCenterMessage();
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
