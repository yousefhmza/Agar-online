import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/modules/ad_type/cubit/ad_type_cubit.dart';
import 'package:agar_online/modules/ad_type/cubit/ad_type_states.dart';
import 'package:agar_online/modules/advertisements/view/components/add_categories_component.dart';
import '../components/add_regions_component.dart';
import '../../../../core/utils/validators.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../../../../core/utils/alerts.dart';
import '../widgets/radio_button_item.dart';
import '../../cubits/add_ads_cubit/add_ads_cubit.dart';
import '../../cubits/add_ads_cubit/add_ads_states.dart';
import '../components/add_images_component.dart';
import '../../../splash/cubit/splash_cubit.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../widgets/check_box_item.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';

class AddAdvertisementScreen extends StatefulWidget {
  const AddAdvertisementScreen({Key? key}) : super(key: key);

  @override
  State<AddAdvertisementScreen> createState() => _AddAdvertisementScreenState();
}

class _AddAdvertisementScreenState extends State<AddAdvertisementScreen> {
  late final AddAdsCubit addAdsCubit;
  late final AdTypesCubit adTypesCubit;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    addAdsCubit = BlocProvider.of<AddAdsCubit>(context);
    adTypesCubit = BlocProvider.of<AdTypesCubit>(context);
    if (addAdsCubit.addAdBody.categoryId != null) adTypesCubit.getAdTypes(addAdsCubit.addAdBody.categoryId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.of<SplashCubit>(context).isAuthed
        ? Column(
            children: [
              CustomAppbar(
                hasTitleSpacing: true,
                title: CustomText(
                  L10n.tr(context).addAdvertisement,
                  fontWeight: FontWeightManager.medium,
                  fontSize: FontSize.s18,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppPadding.p16.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AddCategoriesComponent(),
                        VerticalSpace(AppSize.s16.h),
                        BlocBuilder<AdTypesCubit, AdTypesStates>(
                          buildWhen: (prevState, state) =>
                              state is GetAdTypesLoadingState ||
                              state is GetAdTypesSuccessState ||
                              state is GetAdTypesFailureState,
                          builder: (context, state) {
                            return state.adTypes.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(bottom: AppPadding.p16.h),
                                    child: CustomDropDownField<int?>(
                                      key: UniqueKey(),
                                      value: addAdsCubit.addAdBody.adTypeId,
                                      hintText: L10n.tr(context).adType,
                                      iconSize: state is GetAdTypesLoadingState ? AppSize.s0 : AppSize.s24,
                                      hasLoadingSuffix: state is GetAdTypesLoadingState,
                                      onChanged: (value) => addAdsCubit.addAdBody.copyWith(adTypeId: value),
                                      items: List.generate(
                                        state.adTypes.length,
                                        (index) => DropdownMenuItem<int>(
                                          value: state.adTypes[index].id,
                                          child: CustomText(state.adTypes[index].name),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        CustomTextField(
                          initialValue: addAdsCubit.addAdBody.name,
                          keyBoardType: TextInputType.text,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.notEmptyValidator,
                          hintText: L10n.tr(context).adTitle,
                          onChanged: (value) => addAdsCubit.addAdBody.copyWith(name: value),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        CustomTextField(
                          initialValue: addAdsCubit.addAdBody.desc,
                          hintText: L10n.tr(context).description,
                          maxLines: 9999,
                          minLines: 5,
                          maxLength: 2500,
                          keyBoardType: TextInputType.text,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.notEmptyValidator,
                          onChanged: (value) => addAdsCubit.addAdBody.copyWith(desc: value),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        const AddRegionsComponent(),
                        VerticalSpace(AppSize.s16.h),
                        CustomTextField(
                          initialValue: addAdsCubit.addAdBody.address,
                          hintText: L10n.tr(context).location,
                          keyBoardType: TextInputType.text,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validators.notEmptyValidator,
                          onChanged: (value) => addAdsCubit.addAdBody.copyWith(address: value),
                          suffix: const CustomIcon(Icons.location_on),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        CustomTextField(
                          initialValue: addAdsCubit.addAdBody.price,
                          hintText: L10n.tr(context).price,
                          keyBoardType: TextInputType.number,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: Validators.notEmptyValidator,
                          onChanged: (value) => addAdsCubit.addAdBody.copyWith(price: value),
                        ),
                        VerticalSpace(AppSize.s16.h),
                        CustomText(L10n.tr(context).contactMethod, fontWeight: FontWeightManager.medium),
                        StatefulBuilder(
                          builder: (context, setState) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RadioButtonItem(
                                value: 1,
                                title: L10n.tr(context).phoneWhats,
                                groupValue: addAdsCubit.addAdBody.contact,
                                onChanged: (value) => setState(() => addAdsCubit.addAdBody.copyWith(contact: value!)),
                              ),
                              RadioButtonItem(
                                value: 2,
                                title: L10n.tr(context).chat,
                                groupValue: addAdsCubit.addAdBody.contact,
                                onChanged: (value) => setState(() => addAdsCubit.addAdBody.copyWith(contact: value!)),
                              ),
                              RadioButtonItem(
                                value: 3,
                                title: L10n.tr(context).both,
                                groupValue: addAdsCubit.addAdBody.contact,
                                onChanged: (value) => setState(() => addAdsCubit.addAdBody.copyWith(contact: value!)),
                              ),
                            ],
                          ),
                        ),
                        VerticalSpace(AppSize.s8.h),
                        CustomText(L10n.tr(context).featured, fontWeight: FontWeightManager.medium),
                        StatefulBuilder(
                          builder: (context, setState) => CheckBoxItem(
                            value: addAdsCubit.addAdBody.isFeatured,
                            title: L10n.tr(context).featured,
                            onChanged: (value) => setState(() => addAdsCubit.addAdBody.copyWith(isFeatured: value!)),
                          ),
                        ),
                        VerticalSpace(AppSize.s8.h),
                        const AddImagesComponent(),
                        VerticalSpace(AppSize.s32.h),
                        BlocConsumer<AddAdsCubit, AddAdsStates>(
                          listener: (context, state) {
                            if (state is AddAdFailureState) Alerts.showSnackBar(context, state.failure.message);
                            if (state is AddAdSuccessState) {
                              addAdsCubit.resetValues();
                              BlocProvider.of<LayoutCubit>(context).setCurrentIndex(0);
                              Alerts.showToast(state.message, Toast.LENGTH_LONG);
                            }
                          },
                          builder: (context, state) => state is AddAdLoadingState
                              ? const LoadingSpinner()
                              : CustomButton(
                                  width: double.infinity,
                                  text: L10n.tr(context).addAdvertisement,
                                  onPressed: () {
                                    if (addAdsCubit.addAdBody.images.isEmpty) {
                                      Alerts.showToast(L10n.tr(context).imagesValidator);
                                    }
                                    if (_formKey.currentState!.validate() && addAdsCubit.addAdBody.images.isNotEmpty) {
                                      addAdsCubit.addAd(context);
                                    }
                                  },
                                ),
                        ),
                        VerticalSpace(AppSize.s100.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : const NotLoggedInWidget();
  }
}
