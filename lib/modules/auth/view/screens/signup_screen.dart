import 'dart:io';

import 'package:agar_online/modules/auth/view/components/social_auth_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../../favourites/cubits/favourites_cubit.dart';
import '../components/multi_select_drop_down.dart';
import '../../cubits/signup_cubit/signup_cubit.dart';
import '../../cubits/signup_cubit/signup_states.dart';
import '../../../categories/cubit/categories_cubit.dart';
import '../../../categories/cubit/categories_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../components/pp_agreement.dart';

class SignupScreen extends StatelessWidget {
  final bool reachedFromLogin;

  SignupScreen({required this.reachedFromLogin, Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final SignupCubit signupCubit = BlocProvider.of<SignupCubit>(context);
    final CategoriesCubit categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    if (categoriesCubit.categories.isEmpty) categoriesCubit.getAllCategories();
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
                        CustomText(L10n.tr(context).signup, fontSize: FontSize.s22, fontWeight: FontWeightManager.bold),
                        VerticalSpace(AppSize.s16.h),
                        CustomTextField(
                          hintText: L10n.tr(context).name,
                          keyBoardType: TextInputType.name,
                          controller: signupCubit.nameController,
                          validator: Validators.nameValidator,
                          prefix: const CustomIcon(Icons.person),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        CustomTextField(
                          hintText: L10n.tr(context).mobileNumber,
                          keyBoardType: TextInputType.phone,
                          controller: signupCubit.phoneController,
                          formatters: [LengthLimitingTextInputFormatter(11), FilteringTextInputFormatter.digitsOnly],
                          validator: Validators.mobileNumberValidator,
                          prefix: const CustomIcon(Icons.phone_android),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        CustomTextField(
                          hintText: L10n.tr(context).email,
                          keyBoardType: TextInputType.emailAddress,
                          controller: signupCubit.emailController,
                          validator: Validators.emailValidator,
                          prefix: const CustomIcon(Icons.email),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        BlocBuilder<SignupCubit, SignupStates>(
                          buildWhen: (prevState, state) => state is SetPasswordVisibilityState,
                          builder: (context, state) => CustomTextField(
                            hintText: L10n.tr(context).password,
                            keyBoardType: TextInputType.visiblePassword,
                            obscureText: !signupCubit.isPasswordVisible,
                            controller: signupCubit.passwordController,
                            validator: Validators.passwordValidator,
                            suffix: GestureDetector(
                              onTap: () => signupCubit.setPasswordVisibility(),
                              child:
                                  CustomIcon(signupCubit.isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            ),
                            prefix: const CustomIcon(Icons.lock),
                          ),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        BlocBuilder<SignupCubit, SignupStates>(
                          buildWhen: (prevState, state) => state is SetPasswordVisibilityState,
                          builder: (context, state) => CustomTextField(
                            hintText: L10n.tr(context).confirmPassword,
                            keyBoardType: TextInputType.visiblePassword,
                            obscureText: !signupCubit.isPasswordVisible,
                            controller: signupCubit.confirmPasswordController,
                            validator: (input) =>
                                Validators.confirmPasswordValidator(input, signupCubit.passwordController.text.trim()),
                            prefix: const CustomIcon(Icons.lock),
                          ),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        BlocBuilder<CategoriesCubit, CategoriesStates>(
                          builder: (context, state) => MultiSelectDropDown(
                            interests: categoriesCubit.categories,
                            onChanged: (values) =>
                                signupCubit.interests = values.map((category) => category.id).toList(),
                            hintText: L10n.tr(context).interests,
                          ),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        const PPAgreement(),
                        VerticalSpace(AppSize.s8.h),
                        BlocConsumer<SignupCubit, SignupStates>(
                          listener: (context, state) {
                            if (state is SignupFailureState) Alerts.showSnackBar(context, state.failure.message);
                            if (state is SignupSuccessState) {
                              BlocProvider.of<FavouritesCubit>(context).getFavouriteAds();
                              NavigationService.pushReplacementAll(
                                context,
                                Routes.layoutScreen,
                                arguments: {"from_signup": true},
                              );
                            }
                          },
                          builder: (context, state) => state is SignupLoadingState
                              ? const LoadingSpinner()
                              : SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    text: L10n.tr(context).signup,
                                    onPressed: signupCubit.agreedToTerms
                                        ? () {
                                            if (_formKey.currentState!.validate()) signupCubit.signup();
                                          }
                                        : null,
                                  ),
                                ),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        Row(
                          children: [
                            CustomText(L10n.tr(context).alreadyHaveAccount),
                            HorizontalSpace(AppSize.s8.w),
                            InkWell(
                              onTap: () {
                                if (reachedFromLogin) {
                                  NavigationService.goBack(context);
                                } else {
                                  NavigationService.pushReplacement(context, Routes.loginScreen);
                                }
                              },
                              child: CustomText(
                                L10n.tr(context).login,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
