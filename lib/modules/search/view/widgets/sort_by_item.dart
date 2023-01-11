import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routing/navigation_service.dart';
import '../../../../core/enum/sort_price.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../cubit/search_cubit.dart';

class SortByItem extends StatelessWidget {
  final String title;
  final void Function(SortBy? value) setState;
  final SortBy? value;

  const SortByItem(
      {required this.title,
      required this.value,
      required this.setState,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile<SortBy?>(
      value: value,
      groupValue: BlocProvider.of<SearchCubit>(context).searchParamsBody.sortBy,
      activeColor: AppColors.primaryRed,
      contentPadding: EdgeInsets.zero,
      onChanged: (value) {
        setState(value);
        NavigationService.goBack(context);
        BlocProvider.of<SearchCubit>(context).getSearch();
      },
      title: CustomText(title),
    );
  }
}
