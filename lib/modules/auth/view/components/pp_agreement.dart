import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/core/services/outsource_services.dart';
import 'package:agar_online/modules/auth/cubits/signup_cubit/signup_cubit.dart';
import 'package:agar_online/modules/auth/cubits/signup_cubit/signup_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/view/app_views.dart';

class PPAgreement extends StatelessWidget {
  const PPAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<SignupCubit, SignupStates>(
          buildWhen: (prevState, state) => state is SetTermsAgreementState,
          builder: (context, state) => Checkbox(
            value: BlocProvider.of<SignupCubit>(context).agreedToTerms,
            activeColor: AppColors.primaryRed,
            onChanged: (value) => BlocProvider.of<SignupCubit>(context).setTermsAgreement(value ?? false),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => OutsourceServices.launch(Constants.privacyPolicyUrl),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: L10n.tr(context).byContinuing,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: FontSize.s12.sp,
                      fontWeight: FontWeightManager.medium,
                      fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
                    ),
                  ),
                  TextSpan(
                    text: "${L10n.tr(context).privacyPolicy} ",
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontSize: FontSize.s12.sp,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
                    ),
                  ),
                  TextSpan(
                    text: "${L10n.tr(context).and} ",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: FontSize.s12.sp,
                      fontWeight: FontWeightManager.medium,
                      fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
                    ),
                  ),
                  TextSpan(
                    text: L10n.tr(context).termsOfUsage,
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontSize: FontSize.s12.sp,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
