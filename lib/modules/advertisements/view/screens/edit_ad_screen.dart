import 'package:agar_online/modules/ad_type/cubit/ad_type_states.dart';

import '../../../ad_type/cubit/ad_type_cubit.dart';
import '../../cubits/ads_cubit/ads_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:agar_online/modules/advertisements/view/components/edit_categories_component.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../cubits/edit_ad_cubit/edit_ad_states.dart';
import '../components/edit_images_component.dart';
import '../components/edit_regions_component.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/edit_ad_cubit/edit_ad_cubit.dart';
import '../../models/response/advertisement_model.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/check_box_item.dart';
import '../widgets/radio_button_item.dart';

class EditAdScreen extends StatefulWidget {
  final Advertisement ad;

  const EditAdScreen(this.ad, {Key? key}) : super(key: key);

  @override
  State<EditAdScreen> createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  late final EditAdCubit editAdCubit;
  late final AdTypesCubit adTypesCubit;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    editAdCubit = BlocProvider.of<EditAdCubit>(context);
    adTypesCubit = BlocProvider.of<AdTypesCubit>(context);
    editAdCubit.assignEditAdBody(widget.ad);
    adTypesCubit.getAdTypes(widget.ad.category.id);
    super.initState();
  }

  @override
  void dispose() {
    editAdCubit.editAdBody = null;
    BlocProvider.of<AdsCubit>(NavigationService.navigationKey.currentContext!).fetchMyAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (editAdCubit.editAdBody!.images.isEmpty) {
          Alerts.showToast(L10n.tr(context).imagesValidator);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: CustomText(
            L10n.tr(context).editAdvertisement,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.p16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EditCategoriesComponent(),
                VerticalSpace(AppSize.s16.h),
                BlocBuilder<AdTypesCubit, AdTypesStates>(
                  buildWhen: (prevState, state) =>
                      state is GetAdTypesFailureState ||
                      state is GetAdTypesSuccessState ||
                      state is GetAdTypesLoadingState,
                  builder: (context, state) {
                    return state.adTypes.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(bottom: AppPadding.p16.h),
                            child: CustomDropDownField<int?>(
                              key: UniqueKey(),
                              value: state is GetAdTypesSuccessState ? editAdCubit.editAdBody!.adTypeId : null,
                              hintText: L10n.tr(context).adType,
                              iconSize: state is GetAdTypesLoadingState ? AppSize.s0 : AppSize.s24,
                              hasLoadingSuffix: state is GetAdTypesLoadingState,
                              onChanged: (value) => editAdCubit.editAdBody!.copyWith(adTypeId: value),
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
                  initialValue: editAdCubit.editAdBody!.name,
                  keyBoardType: TextInputType.text,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.notEmptyValidator,
                  hintText: L10n.tr(context).adTitle,
                  onChanged: (value) => editAdCubit.editAdBody!.copyWith(name: value),
                ),
                VerticalSpace(AppSize.s16.h),
                CustomTextField(
                  initialValue: editAdCubit.editAdBody!.desc,
                  hintText: L10n.tr(context).description,
                  maxLines: 5,
                  minLines: 5,
                  maxLength: 250,
                  keyBoardType: TextInputType.text,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.notEmptyValidator,
                  onChanged: (value) => editAdCubit.editAdBody!.copyWith(desc: value),
                ),
                VerticalSpace(AppSize.s16.h),
                const EditRegionsComponent(),
                VerticalSpace(AppSize.s16.h),
                CustomTextField(
                  initialValue: editAdCubit.editAdBody!.address,
                  hintText: L10n.tr(context).location,
                  keyBoardType: TextInputType.text,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validators.notEmptyValidator,
                  onChanged: (value) => editAdCubit.editAdBody!.copyWith(address: value),
                  suffix: const CustomIcon(Icons.location_on),
                ),
                VerticalSpace(AppSize.s16.h),
                CustomTextField(
                  initialValue: editAdCubit.editAdBody!.price,
                  hintText: L10n.tr(context).price,
                  keyBoardType: TextInputType.number,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.notEmptyValidator,
                  onChanged: (value) => editAdCubit.editAdBody!.copyWith(price: value),
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
                        groupValue: editAdCubit.editAdBody!.contact,
                        onChanged: (value) => setState(() => editAdCubit.editAdBody!.copyWith(contact: value!)),
                      ),
                      RadioButtonItem(
                        value: 2,
                        title: L10n.tr(context).chat,
                        groupValue: editAdCubit.editAdBody!.contact,
                        onChanged: (value) => setState(() => editAdCubit.editAdBody!.copyWith(contact: value!)),
                      ),
                      RadioButtonItem(
                        value: 3,
                        title: L10n.tr(context).both,
                        groupValue: editAdCubit.editAdBody!.contact,
                        onChanged: (value) => setState(() => editAdCubit.editAdBody!.copyWith(contact: value!)),
                      ),
                    ],
                  ),
                ),
                VerticalSpace(AppSize.s8.h),
                CustomText(L10n.tr(context).featured, fontWeight: FontWeightManager.medium),
                StatefulBuilder(
                  builder: (context, setState) => CheckBoxItem(
                    value: editAdCubit.editAdBody!.isFeatured,
                    title: L10n.tr(context).featured,
                    onChanged: (value) => setState(() => editAdCubit.editAdBody!.copyWith(isFeatured: value!)),
                  ),
                ),
                VerticalSpace(AppSize.s8.h),
                const EditImagesComponent(),
                VerticalSpace(AppSize.s32.h),
                BlocConsumer<EditAdCubit, EditAdStates>(
                  listener: (context, state) {
                    if (state is EditAdFailureState) Alerts.showSnackBar(context, state.failure.message);
                    if (state is EditAdSuccessState) {
                      NavigationService.goBack(context);
                      Alerts.showToast(state.message, Toast.LENGTH_LONG);
                    }
                  },
                  builder: (context, state) => state is EditAdLoadingState
                      ? const LoadingSpinner()
                      : CustomButton(
                          width: double.infinity,
                          text: L10n.tr(context).editAdvertisement,
                          onPressed: () {
                            if (editAdCubit.editAdBody!.images.isEmpty) {
                              Alerts.showToast(L10n.tr(context).imagesValidator);
                            }
                            if (_formKey.currentState!.validate() && editAdCubit.editAdBody!.images.isNotEmpty) {
                              editAdCubit.editAdd(context);
                            }
                          },
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
