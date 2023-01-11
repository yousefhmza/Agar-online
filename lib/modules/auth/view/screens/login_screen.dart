import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/modules/auth/view/components/forget_password_sheet.dart';
import 'package:agar_online/modules/auth/view/components/social_auth_component.dart';
import 'package:agar_online/modules/favourites/cubits/favourites_cubit.dart';
import '../../../../core/utils/validators.dart';
import '../../cubits/login_cubit/login_cubit.dart';
import '../../cubits/login_cubit/login_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = BlocProvider.of<LoginCubit>(context);
    return StatusBar(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p16.w),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => NavigationService.goBack(context),
                          child: CustomIcon(Icons.adaptive.arrow_back),
                        ),
                        Center(
                          child: Image.asset(
                            L10n.isAr(context) ? AppImages.arabicLogo : AppImages.englishLogo,
                            height: AppSize.s200.w,
                            width: AppSize.s200.w,
                          ),
                        ),
                        CustomText(L10n.tr(context).login, fontSize: FontSize.s22, fontWeight: FontWeightManager.bold),
                        VerticalSpace(AppSize.s16.h),
                        CustomTextField(
                          hintText: L10n.tr(context).mobileNumber,
                          keyBoardType: TextInputType.phone,
                          controller: loginCubit.phoneController,
                          formatters: [LengthLimitingTextInputFormatter(11), FilteringTextInputFormatter.digitsOnly],
                          validator: Validators.mobileNumberValidator,
                          prefix: const CustomIcon(Icons.phone_android),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        BlocBuilder<LoginCubit, LoginStates>(
                          buildWhen: (prevState, state) => state is SetPasswordVisibilityState,
                          builder: (context, state) => CustomTextField(
                            hintText: L10n.tr(context).password,
                            keyBoardType: TextInputType.visiblePassword,
                            obscureText: !loginCubit.isPasswordVisible,
                            controller: loginCubit.passwordController,
                            validator: Validators.passwordValidator,
                            suffix: GestureDetector(
                              onTap: () => loginCubit.setPasswordVisibility(),
                              child: CustomIcon(loginCubit.isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            ),
                            prefix: const CustomIcon(Icons.lock),
                          ),
                        ),
                        VerticalSpace(AppSize.s8.h),
                        InkWell(
                          onTap: () => Alerts.showBottomSheet(context, child: ForgetPasswordSheet(), expandable: false),
                          child: CustomText(
                            L10n.tr(context).forgetPassword,
                            color: AppColors.primaryRed,
                            fontWeight: FontWeightManager.bold,
                          ),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        BlocConsumer<LoginCubit, LoginStates>(
                          listener: (context, state) {
                            if (state is LoginFailureState) Alerts.showSnackBar(context, state.failure.message);
                            if (state is LoginSuccessState) {
                              BlocProvider.of<FavouritesCubit>(context).getFavouriteAds();
                              NavigationService.pushReplacementAll(
                                context,
                                Routes.layoutScreen,
                                arguments: {"from_signup": false},
                              );
                            }
                          },
                          builder: (context, state) => state is LoginLoadingState
                              ? const LoadingSpinner()
                              : SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    text: L10n.tr(context).login,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) loginCubit.login();
                                    },
                                  ),
                                ),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        Row(
                          children: [
                            CustomText(L10n.tr(context).hasNoAccount),
                            HorizontalSpace(AppSize.s8.w),
                            InkWell(
                              onTap: () =>
                                  NavigationService.push(context, Routes.signupScreen, arguments: {"from_login": true}),
                              child: CustomText(
                                L10n.tr(context).signup,
                                color: AppColors.primaryRed,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ),
                          ],
                        ),
                        VerticalSpace(AppSize.s16.h),
                        if (!Platform.isIOS)
                          const Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SocialAuthComponent(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
