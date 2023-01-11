import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/enum/category_type.dart';
import 'package:agar_online/modules/categories/cubit/categories_cubit.dart';
import 'package:agar_online/modules/categories/cubit/categories_states.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/view/app_views.dart';

class CategoriesDropDownField extends StatelessWidget {
  final CategoryType categoryType;
  final String failureMessage;
  final VoidCallback retryAction;
  final int? value;
  final String hintText;
  final void Function(int?) onChanged;

  const CategoriesDropDownField({
    required this.categoryType,
    required this.failureMessage,
    required this.retryAction,
    required this.value,
    required this.hintText,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesStates>(
      listenWhen: (prevState, state) => state is GetCategoriesFailureState && state.categoryType == categoryType,
      listener: (context, state) {
        if (state is GetCategoriesFailureState && state.categoryType == categoryType) {
          Alerts.showActionSnackBar(
            context,
            message: failureMessage,
            actionLabel: L10n.tr(context).retry,
            onActionPressed: retryAction,
          );
        }
      },
      buildWhen: (prevState, state) =>
          (state is GetCategoriesLoadingState && state.categoryType == categoryType) ||
          (state is GetCategoriesFailureState && state.categoryType == categoryType) ||
          (state is GetCategoriesSuccessState && state.categoryType == categoryType),
      builder: (context, state) => CustomDropDownField<int?>(
        key: UniqueKey(),
        value: state is GetCategoriesLoadingState || state is GetCategoriesFailureState ? null : value,
        hintText: hintText,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        validator: Validators.notEmptyDropDownValidator,
        onChanged: onChanged,
        items: List.generate(
          state.items.length,
          (index) => DropdownMenuItem<int>(value: state.items[index].id, child: CustomText(state.items[index].name)),
        ),
        iconSize: (state is GetCategoriesLoadingState && state.categoryType == categoryType) ? AppSize.s0 : AppSize.s24,
        hasLoadingSuffix: (state is GetCategoriesLoadingState && state.categoryType == categoryType),
      ),
    );
  }
}
