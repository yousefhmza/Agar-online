import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/view/components/empty_component.dart';
import 'package:agar_online/modules/advertisements/models/body/filter_ads_body.dart';
import 'package:agar_online/modules/categories/view/components/filter_by_type_button.dart';
import 'package:agar_online/modules/advertisements/cubits/ads_cubit/ads_cubit.dart';
import 'package:agar_online/modules/advertisements/cubits/ads_cubit/ads_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../ad_type/cubit/ad_type_cubit.dart';
import '../../../advertisements/view/widgets/ad_item.dart';
import '../../models/sub_sub_category_model.dart';
import '../widgets/sub_cat_chip.dart';

class SubSubCategoryScreen extends StatefulWidget {
  final int categoryId;
  final String subCategoryName;
  final SubSubCategory subSubCategory;
  final List<SubSubCategory> allSubSubCategories; // all sub-sub-categories in this sub category

  const SubSubCategoryScreen({
    required this.categoryId,
    required this.subCategoryName,
    required this.subSubCategory,
    required this.allSubSubCategories,
    Key? key,
  }) : super(key: key);

  @override
  State<SubSubCategoryScreen> createState() => _SubSubCategoryScreenState();
}

class _SubSubCategoryScreenState extends State<SubSubCategoryScreen> {
  late final AdsCubit adsCubit;
  final GlobalKey selectedChipKey = GlobalKey();

  @override
  void initState() {
    adsCubit = BlocProvider.of<AdsCubit>(context);
    adsCubit.filterAdsBody = FilterAdsBody(subSubCategoryId: widget.subSubCategory.id);
    adsCubit.fetchAdsBySubSubCategoryAndAdType();
    BlocProvider.of<AdTypesCubit>(context).getAdTypes(widget.categoryId);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Scrollable.ensureVisible(selectedChipKey.currentContext!, alignment: 0.5);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: CustomText(widget.subCategoryName, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
        actions: const [FilterByTypeButton()],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSize.s86.h,
              child: BlocBuilder<AdsCubit, AdsStates>(
                buildWhen: (_, state) => state is GetAdsBySubSubCategoryLoadingState,
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s8.w),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        widget.allSubSubCategories.length,
                        (index) => SubSubCatChip(
                          key: adsCubit.filterAdsBody.subSubCategoryId == widget.allSubSubCategories[index].id
                              ? selectedChipKey
                              : null,
                          subSubCategory: widget.allSubSubCategories[index],
                          isSelected: adsCubit.filterAdsBody.subSubCategoryId == widget.allSubSubCategories[index].id,
                          title: widget.allSubSubCategories[index].name,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          BlocBuilder<AdsCubit, AdsStates>(
            buildWhen: (_, state) =>
                state is GetAdsBySubSubCategoryLoadingState ||
                state is GetAdsBySubSubCategorySuccessState ||
                state is GetAdsBySubSubCategoryFailureState,
            builder: (context, state) {
              if (state is GetAdsBySubSubCategorySuccessState) {
                return state.ads.isNotEmpty
                    ? SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.w),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => AdItem(state.ads[index]),
                            childCount: state.ads.length,
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppSize.s8.w,
                            mainAxisSpacing: AppSize.s16.w,
                            childAspectRatio: 0.65,
                          ),
                        ),
                      )
                    : SliverFillRemaining(
                        child: EmptyComponent(text: L10n.tr(context).noAdsFound),
                      );
              }
              if (state is GetAdsBySubSubCategoryFailureState) {
                return SliverFillRemaining(
                  child: ErrorComponent(
                    errorMessage: state.failure.message,
                    onRetry: () => adsCubit.fetchAdsBySubSubCategoryAndAdType(),
                  ),
                );
              }
              return const SliverFillRemaining(child: LoadingSpinner());
            },
          ),
        ],
      ),
    );
  }
}
