import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../regions/cubit/regions_cubit.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/enum/region_type.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/view/app_views.dart';
import '../../../regions/cubit/regions_states.dart';

class RegionDropDownField extends StatelessWidget {
  final RegionType regionType;
  final String failureMessage;
  final VoidCallback retryAction;
  final int? value;
  final String hintText;
  final bool hasValidation;
  final void Function(int?) onChanged;

  const RegionDropDownField({
    required this.regionType,
    required this.failureMessage,
    required this.retryAction,
    required this.value,
    required this.hintText,
    required this.hasValidation,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionsCubit, RegionsStates>(
      listenWhen: (prevState, state) => state is GetRegionFailureState && state.regionType == regionType,
      listener: (context, state) {
        if (state is GetRegionFailureState && state.regionType == regionType) {
          Alerts.showActionSnackBar(
            context,
            message: failureMessage,
            actionLabel: L10n.tr(context).retry,
            onActionPressed: retryAction,
          );
        }
      },
      buildWhen: (prevState, state) =>
          (state is GetRegionLoadingState && state.regionType == regionType) ||
          (state is GetRegionFailureState && state.regionType == regionType) ||
          (state is GetRegionSuccessState && state.regionType == regionType),
      builder: (context, state) => CustomDropDownField<int?>(
        key: UniqueKey(),
        value: state is GetRegionLoadingState || state is GetRegionFailureState ? null : value,
        hintText: hintText,
        autoValidateMode: hasValidation ? AutovalidateMode.onUserInteraction : null,
        validator: hasValidation ? Validators.notEmptyDropDownValidator : null,
        onChanged: onChanged,
        items: List.generate(
          state.regions.length,
          (index) => DropdownMenuItem<int>(
            value: state.regions[index].id,
            child: CustomText(state.regions[index].name),
          ),
        ),
        iconSize: (state is GetRegionLoadingState && state.regionType == regionType) ? AppSize.s0 : AppSize.s24,
        hasLoadingSuffix: (state is GetRegionLoadingState && state.regionType == regionType),
      ),
    );
  }
}
