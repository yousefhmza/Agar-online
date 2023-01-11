import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/view/components/empty_component.dart';
import '../components/filter_bottom_sheet.dart';
import '../components/sort_bottom_sheet.dart';
import '../../../../core/utils/alerts.dart';
import '../../cubit/search_cubit.dart';
import '../../cubit/search_states.dart';
import '../../models/body/search_params_body.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../advertisements/view/widgets/ad_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchCubit searchCubit;

  @override
  void initState() {
    searchCubit = BlocProvider.of<SearchCubit>(context);
    searchCubit.searchParamsBody = SearchParamsBody();
    searchCubit.initSearchState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSize.s0,
        toolbarHeight: AppSize.s64.h,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: SizedBox(
          height: AppSize.s48.h,
          child: CustomTextField(
            hintText: L10n.tr(context).search,
            textInputAction: TextInputAction.search,
            onChanged: (value) => searchCubit.searchParamsBody.copyWith(name: value),
            onSubmitted: (value) => searchCubit.getSearch(),
          ),
        ),
        actions: [
          CustomIconButton(
            icon: Icons.filter_alt_outlined,
            onPressed: () => Alerts.showBottomSheet(context, child: const FilterBottomSheet(), expandable: true),
          ),
          RotatedBox(
            quarterTurns: 1,
            child: CustomIconButton(
              icon: Icons.compare_arrows,
              onPressed: () => Alerts.showBottomSheet(context, child: const SortBottomSheet(), expandable: false),
            ),
          )
        ],
      ),
      body: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          if (state is GetSearchFailureState) {
            Alerts.showActionSnackBar(
              context,
              message: state.failure.message,
              actionLabel: L10n.tr(context).retry,
              onActionPressed: () => searchCubit.getSearch(),
            );
          }
        },
        buildWhen: (_, state) =>
            state is GetSearchSuccessState || state is GetSearchLoadingState || state is GetSearchFailureState,
        builder: (context, state) {
          if (state is GetSearchLoadingState) return const LoadingSpinner();
          if (state is GetSearchSuccessState) {
            return state.ads.isNotEmpty
                ? GridView.builder(
                    padding: EdgeInsets.all(AppPadding.p16.w),
                    itemCount: state.ads.length,
                    itemBuilder: (context, index) => AdItem(state.ads[index]),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSize.s8.w,
                      mainAxisSpacing: AppSize.s16.w,
                      childAspectRatio: 0.65,
                    ),
                  )
                : EmptyComponent(text: L10n.tr(context).emptySearchResults);
          }
          return EmptyComponent(text: L10n.tr(context).noSearchResults);
        },
      ),
    );
  }
}
