import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/modules/profile/view/widgets/delete_account_button.dart';
import 'package:agar_online/modules/auth/view/components/multi_select_drop_down.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../core/utils/alerts.dart';
import '../../../categories/cubit/categories_cubit.dart';
import '../../../categories/cubit/categories_states.dart';
import '../../cubits/profile_cubit.dart';
import '../../cubits/profile_states.dart';
import '../../../../core/utils/globals.dart';
import '../../models/body/profile_body.dart';
import '../components/profile_avatar_component.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileBody profileBody = ProfileBody(
    interests: currentUser!.interests.map((category) => category.id).toList(),
  );

  @override
  Widget build(BuildContext context) {
    final CategoriesCubit categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    if (categoriesCubit.categories.isEmpty) categoriesCubit.getAllCategories();
    return Scaffold(
      appBar: CustomAppbar(
        title: CustomText(L10n.tr(context).editProfile, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppPadding.p16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfileAvatarComponent(profileBody: profileBody),
              VerticalSpace(AppSize.s16.h),
              CustomTextField(
                hintText: L10n.tr(context).name,
                initialValue: currentUser!.name,
                keyBoardType: TextInputType.name,
                validator: Validators.notEmptyValidator,
                onSaved: (value) => profileBody.copyWith(name: value),
                prefix: const CustomIcon(Icons.person),
              ),
              VerticalSpace(AppSize.s16.h),
              CustomTextField(
                hintText: L10n.tr(context).mobileNumber,
                initialValue: currentUser!.phone,
                keyBoardType: TextInputType.phone,
                validator: Validators.mobileNumberValidator,
                onSaved: (value) => profileBody.copyWith(phone: value),
                prefix: const CustomIcon(Icons.phone_android),
              ),
              VerticalSpace(AppSize.s16.h),
              CustomTextField(
                hintText: L10n.tr(context).email,
                initialValue: currentUser!.email,
                keyBoardType: TextInputType.emailAddress,
                validator: Validators.emailValidator,
                onSaved: (value) => profileBody.copyWith(email: value),
                prefix: const CustomIcon(Icons.email),
              ),
              VerticalSpace(AppSize.s16.h),
              CustomTextField(
                hintText: L10n.tr(context).address,
                initialValue: currentUser!.address,
                keyBoardType: TextInputType.text,
                onSaved: (value) => profileBody.copyWith(address: value),
                prefix: const CustomIcon(Icons.location_on),
              ),
              VerticalSpace(AppSize.s16.h),
              BlocBuilder<CategoriesCubit, CategoriesStates>(
                builder: (context, state) => MultiSelectDropDown(
                  userInterests: currentUser!.interests,
                  interests: categoriesCubit.categories,
                  onChanged: (values) =>
                      profileBody.copyWith(interests: values.map((category) => category.id).toList()),
                  hintText: L10n.tr(context).interests,
                ),
              ),
              VerticalSpace(AppSize.s32.h),
              BlocConsumer<ProfileCubit, ProfileStates>(
                listener: (context, state) {
                  if (state is EditProfileFailureState) Alerts.showSnackBar(context, state.failure.message);
                  if (state is EditProfileSuccessState) NavigationService.goBack(context);
                },
                builder: (context, state) {
                  return state is EditProfileLoadingState
                      ? const LoadingSpinner()
                      : CustomButton(
                          width: double.infinity,
                          text: L10n.tr(context).edit,
                          onPressed: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<ProfileCubit>(context).editProfile(profileBody);
                            }
                          },
                        );
                },
              ),
              VerticalSpace(AppSize.s16.h),
              const DeleteAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}
