import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/region_drop_down_field.dart';
import '../../../../core/enum/region_type.dart';
import '../../../regions/cubit/regions_cubit.dart';
import '../../cubits/edit_ad_cubit/edit_ad_cubit.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class EditRegionsComponent extends StatefulWidget {
  const EditRegionsComponent({Key? key}) : super(key: key);

  @override
  State<EditRegionsComponent> createState() => _EditRegionsComponentState();
}

class _EditRegionsComponentState extends State<EditRegionsComponent> {
  late final EditAdCubit editAdCubit;
  late final RegionsCubit regionsCubit;

  @override
  void initState() {
    editAdCubit = BlocProvider.of<EditAdCubit>(context);
    regionsCubit = BlocProvider.of<RegionsCubit>(context);
    regionsCubit.getCities();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editAdCubit.editAdBody!.cityId != null) regionsCubit.getCityAreas(editAdCubit.editAdBody!.cityId!);
      if (editAdCubit.editAdBody!.cityId != null && editAdCubit.editAdBody!.areaId != null) {
        regionsCubit.getSubAreas(editAdCubit.editAdBody!.areaId!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RegionDropDownField(
          regionType: RegionType.city,
          failureMessage: L10n.tr(context).getCitiesFailure,
          retryAction: () => regionsCubit.getCities(),
          value: editAdCubit.editAdBody!.cityId,
          hintText: L10n.tr(context).city,
          hasValidation: true,
          onChanged: (value) {
            editAdCubit.editAdBody!.areaId = null;
            editAdCubit.editAdBody!.subAreaId = null;
            editAdCubit.editAdBody!.copyWith(cityId: value);
            regionsCubit.getCityAreas(editAdCubit.editAdBody!.cityId!);
            regionsCubit.resetSubAreas();
          },
        ),
        VerticalSpace(AppSize.s16.h),
        RegionDropDownField(
          regionType: RegionType.cityArea,
          failureMessage: L10n.tr(context).getCityAreasFailure,
          retryAction: () => regionsCubit.getCityAreas(editAdCubit.editAdBody!.cityId!),
          value: editAdCubit.editAdBody!.areaId,
          hintText: L10n.tr(context).cityArea,
          hasValidation: true,
          onChanged: (value) {
            editAdCubit.editAdBody!.subAreaId = null;
            editAdCubit.editAdBody!.copyWith(areaId: value);
            regionsCubit.getSubAreas(editAdCubit.editAdBody!.areaId!);
          },
        ),
        VerticalSpace(AppSize.s16.h),
        RegionDropDownField(
          regionType: RegionType.subArea,
          failureMessage: L10n.tr(context).getSubAreasFailure,
          retryAction: () => regionsCubit.getSubAreas(editAdCubit.editAdBody!.areaId!),
          value: editAdCubit.editAdBody!.subAreaId,
          hintText: L10n.tr(context).subArea,
          hasValidation: false,
          onChanged: (value) => editAdCubit.editAdBody!.copyWith(subAreaId: value),
        ),
      ],
    );
  }
}
