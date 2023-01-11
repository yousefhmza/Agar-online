import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../regions/cubit/regions_cubit.dart';
import '../../../../core/enum/region_type.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/add_ads_cubit/add_ads_cubit.dart';
import '../widgets/region_drop_down_field.dart';

class AddRegionsComponent extends StatefulWidget {
  const AddRegionsComponent({Key? key}) : super(key: key);

  @override
  State<AddRegionsComponent> createState() => _AddRegionsComponentState();
}

class _AddRegionsComponentState extends State<AddRegionsComponent> {
  late final AddAdsCubit addAdsCubit;
  late final RegionsCubit regionsCubit;

  @override
  void initState() {
    addAdsCubit = BlocProvider.of<AddAdsCubit>(context);
    regionsCubit = BlocProvider.of<RegionsCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      regionsCubit.resetAreas();
      regionsCubit.resetSubAreas();
      regionsCubit.getCities();
      if (addAdsCubit.addAdBody.cityId != null) regionsCubit.getCityAreas(addAdsCubit.addAdBody.cityId!);
      if (addAdsCubit.addAdBody.cityId != null && addAdsCubit.addAdBody.areaId != null) {
        regionsCubit.getSubAreas(addAdsCubit.addAdBody.areaId!);
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
          value: addAdsCubit.addAdBody.cityId,
          hintText: L10n.tr(context).city,
          hasValidation: true,
          onChanged: (value) {
            addAdsCubit.addAdBody.areaId = null;
            addAdsCubit.addAdBody.subAreaId = null;
            addAdsCubit.addAdBody.copyWith(cityId: value);
            regionsCubit.getCityAreas(addAdsCubit.addAdBody.cityId!);
            regionsCubit.resetSubAreas();
          },
        ),
        VerticalSpace(AppSize.s16.h),
        RegionDropDownField(
          regionType: RegionType.cityArea,
          failureMessage: L10n.tr(context).getCityAreasFailure,
          retryAction: () => regionsCubit.getCityAreas(addAdsCubit.addAdBody.cityId!),
          value: addAdsCubit.addAdBody.areaId,
          hintText: L10n.tr(context).cityArea,
          hasValidation: true,
          onChanged: (value) {
            addAdsCubit.addAdBody.subAreaId = null;
            addAdsCubit.addAdBody.copyWith(areaId: value);
            regionsCubit.getSubAreas(addAdsCubit.addAdBody.areaId!);
          },
        ),
        VerticalSpace(AppSize.s16.h),
        RegionDropDownField(
          regionType: RegionType.subArea,
          failureMessage: L10n.tr(context).getSubAreasFailure,
          retryAction: () => regionsCubit.getSubAreas(addAdsCubit.addAdBody.areaId!),
          value: addAdsCubit.addAdBody.subAreaId,
          hintText: L10n.tr(context).subArea,
          hasValidation: false,
          onChanged: (value) => addAdsCubit.addAdBody.copyWith(subAreaId: value),
        ),
      ],
    );
  }
}
