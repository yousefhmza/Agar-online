import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/core/view/app_views.dart';
import 'package:agar_online/modules/ad_type/cubit/ad_type_cubit.dart';
import 'package:agar_online/modules/ad_type/cubit/ad_type_states.dart';
import 'package:agar_online/modules/advertisements/cubits/ads_cubit/ads_cubit.dart';
import 'package:agar_online/modules/categories/view/widgets/filter_menu_item.dart';

class FilterByTypeButton extends StatelessWidget {
  const FilterByTypeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdsCubit adsCubit = BlocProvider.of<AdsCubit>(context);
    return BlocBuilder<AdTypesCubit, AdTypesStates>(
      builder: (context, state) {
        return PopupMenuButton<int?>(
          itemBuilder: (context) => [
            FilterMenuItem<int?>(
              value: null,
              onTap: () {
                adsCubit.filterAdsBody.adTypeId = null;
                adsCubit.fetchAdsBySubSubCategoryAndAdType();
              },
              isSelected: adsCubit.filterAdsBody.adTypeId == null,
              text: L10n.tr(context).none,
            ),
            ...List.generate(
              state.adTypes.length,
              (index) => FilterMenuItem<int?>(
                value: state.adTypes[index].id,
                isSelected: adsCubit.filterAdsBody.adTypeId == state.adTypes[index].id,
                text: state.adTypes[index].name,
              ),
            )
          ],
          elevation: AppSize.s4.h,
          onSelected: (value) {
            adsCubit.filterAdsBody.adTypeId = value;
            adsCubit.fetchAdsBySubSubCategoryAndAdType();
          },
          icon: const CustomIcon(Icons.filter_list),
        );
      },
    );
  }
}
