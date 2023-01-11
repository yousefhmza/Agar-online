import '../widgets/sort_by_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/enum/sort_price.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../cubit/search_cubit.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchCubit searchCubit = BlocProvider.of<SearchCubit>(context);
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(L10n.tr(context).sortBy,
                fontWeight: FontWeightManager.bold, fontSize: FontSize.s16),
            SortByItem(
              title: L10n.tr(context).none,
              value: null,
              setState: (value) =>
                  setState(() => searchCubit.searchParamsBody.sortBy = null),
            ),
            SortByItem(
              title: L10n.tr(context).newest,
              value: SortBy.newest,
              setState: (value) =>
                  setState(() => searchCubit.searchParamsBody.sortBy = value),
            ),
            SortByItem(
              title: L10n.tr(context).featured,
              value: SortBy.featured,
              setState: (value) =>
                  setState(() => searchCubit.searchParamsBody.sortBy = value),
            ),
            SortByItem(
              title: L10n.tr(context).highestPrice,
              value: SortBy.htl,
              setState: (value) =>
                  setState(() => searchCubit.searchParamsBody.sortBy = value),
            ),
            SortByItem(
              title: L10n.tr(context).lowestPrice,
              value: SortBy.lth,
              setState: (value) =>
                  setState(() => searchCubit.searchParamsBody.sortBy = value),
            ),
          ],
        );
      },
    );
  }
}
