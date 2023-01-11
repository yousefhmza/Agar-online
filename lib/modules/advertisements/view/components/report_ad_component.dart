import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/config/routing/navigation_service.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/core/utils/globals.dart';
import 'package:agar_online/core/utils/validators.dart';
import 'package:agar_online/core/view/app_views.dart';
import 'package:agar_online/modules/reports/cubits/reports_cubit.dart';
import 'package:agar_online/modules/reports/cubits/reports_states.dart';
import 'package:agar_online/modules/reports/models/body/report_ad_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../block/cubits/block_cubit.dart';

class ReportComponent extends StatelessWidget {
  final int? advertiserId;

  ReportComponent({this.advertiserId, Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ReportAdBody reportAdBody = ReportAdBody();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (advertiserId == null)
            CustomTextField(
              hintText: L10n.tr(context).name,
              onSaved: (value) => reportAdBody.copyWith(name: value),
              validator: Validators.notEmptyValidator,
            ),
          if (advertiserId == null) VerticalSpace(AppSize.s8.h),
          if (advertiserId == null)
            CustomTextField(
              hintText: L10n.tr(context).mobileNumber,
              onSaved: (value) => reportAdBody.copyWith(phone: value),
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.mobileNumberValidator,
            ),
          if (advertiserId == null) VerticalSpace(AppSize.s8.h),
          if (advertiserId == null)
            CustomTextField(
              hintText: L10n.tr(context).email,
              onSaved: (value) => reportAdBody.copyWith(email: value),
              validator: Validators.emailValidator,
            ),
          if (advertiserId == null) VerticalSpace(AppSize.s8.h),
          CustomTextField(
            hintText: L10n.tr(context).enterMessageText,
            onSaved: (value) => reportAdBody.copyWith(message: value),
            validator: Validators.notEmptyValidator,
          ),
          VerticalSpace(AppSize.s16.h),
          BlocConsumer<ReportsCubit, ReportsStates>(
            listener: (context, state) {
              if (state is ReportSuccessState) {
                NavigationService.goBack(context);
                Alerts.showToast(state.message);
              }
              if (state is ReportFailureState) {
                Alerts.showToast(state.failure.message);
              }
            },
            builder: (context, state) => state is ReportLoadingState
                ? const LoadingSpinner()
                : Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              advertiserId == null
                                  ? BlocProvider.of<ReportsCubit>(context).reportAd(reportAdBody)
                                  : BlocProvider.of<ReportsCubit>(context)
                                      .reportUser(advertiserId!, reportAdBody.message);
                            }
                          },
                          text: L10n.tr(context).send,
                        ),
                      ),
                      if (currentUser != null && advertiserId != null) HorizontalSpace(AppSize.s16.w),
                      if (currentUser != null && advertiserId != null)
                        Expanded(
                          child: CustomButton(
                            onPressed: () async {
                              await NavigationService.goBack(context);
                              // ignore: use_build_context_synchronously
                              Alerts.showAppDialog(
                                context,
                                title: L10n.tr(context).blockUser,
                                onConfirm: () => BlocProvider.of<BlockCubit>(context).blockUser(advertiserId!),
                                confirmText: L10n.tr(context).confirm,
                              );
                            },
                            text: L10n.tr(context).block,
                            color: AppColors.white,
                            textColor: AppColors.red,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
