import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/pickers.dart';
import '../../cubits/add_ads_cubit/add_ads_cubit.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class AddImagesComponent extends StatelessWidget {
  const AddImagesComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddAdsCubit addAdsCubit = BlocProvider.of<AddAdsCubit>(context);
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.s8.r),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.r),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  final List<File> images = await Pickers.pickMultiImages();
                  addAdsCubit.addAdBody.images.addAll(images);
                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppPadding.p8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(L10n.tr(context).uploadUpTo5, fontWeight: FontWeightManager.medium),
                      const CustomIcon(Icons.add_circle_outline, size: FontSize.s20),
                    ],
                  ),
                ),
              ),
              addAdsCubit.addAdBody.images.isEmpty
                  ? InkWell(
                      onTap: () async {
                        final List<File> images = await Pickers.pickMultiImages();
                        addAdsCubit.addAdBody.images.addAll(images);
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: AppSize.s125.h,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: AppSize.s2.r,
                            colors: const [AppColors.primaryRed, AppColors.primaryBlue],
                          ),
                        ),
                        padding: EdgeInsets.all(AppPadding.p8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomIcon(Icons.add_circle_outline, color: AppColors.white),
                            HorizontalSpace(AppSize.s8.w),
                            CustomText(
                              L10n.tr(context).addImages,
                              fontWeight: FontWeightManager.bold,
                              color: AppColors.white,
                              fontSize: FontSize.s18,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: AppSize.s100.h,
                      child: Theme(
                        data: Theme.of(context).copyWith(canvasColor: AppColors.transparent),
                        child: ReorderableListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: addAdsCubit.addAdBody.images.length,
                          itemBuilder: (context, index) => _AdImage(
                            key: ValueKey(addAdsCubit.addAdBody.images[index].path),
                            image: addAdsCubit.addAdBody.images[index],
                            onDelete: () => setState(() => addAdsCubit.addAdBody.images.removeAt(index)),
                          ),
                          onReorder: (oldIndex, newIndex) {
                            final int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
                            final File image = addAdsCubit.addAdBody.images.removeAt(oldIndex);
                            addAdsCubit.addAdBody.images.insert(index, image);
                          },
                        ),
                      ),
                    ),
              if (addAdsCubit.addAdBody.images.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(AppPadding.p8.w),
                  child: CustomText(L10n.tr(context).uploadImagesHint, fontSize: FontSize.s12),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AdImage extends StatelessWidget {
  final File image;
  final VoidCallback onDelete;

  const _AdImage({required this.image, required this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSize.s4.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s8.r),
            child: Image.file(image, width: AppSize.s100.w, height: AppSize.s100.w, fit: BoxFit.cover),
          ),
          PositionedDirectional(
            top: AppSize.s4.h,
            start: AppSize.s4.h,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(AppPadding.p4.w),
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const CustomIcon(Icons.delete_rounded, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
