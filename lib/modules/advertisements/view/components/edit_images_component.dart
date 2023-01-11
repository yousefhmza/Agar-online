import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/response/ad_image_model.dart';
import '../../cubits/edit_ad_cubit/edit_ad_states.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../cubits/edit_ad_cubit/edit_ad_cubit.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

import '../../../../core/utils/pickers.dart';

class EditImagesComponent extends StatelessWidget {
  const EditImagesComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditAdCubit editAdCubit = BlocProvider.of<EditAdCubit>(context);
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
                  editAdCubit.editAdBody!.images.insertAll(0, images);
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
              editAdCubit.editAdBody!.images.isEmpty
                  ? InkWell(
                      onTap: () async {
                        final List<File> images = await Pickers.pickMultiImages();
                        editAdCubit.editAdBody!.images.insertAll(0, images);
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
                          itemCount: editAdCubit.editAdBody!.images.length,
                          itemBuilder: (context, index) => _AdImage(
                            key: editAdCubit.editAdBody!.images[index] is AdImage
                                ? ValueKey(editAdCubit.editAdBody!.images[index].image)
                                : ValueKey(editAdCubit.editAdBody!.images[index].path),
                            image: editAdCubit.editAdBody!.images[index],
                            onDelete: () async {
                              await editAdCubit.deleteAdImage(editAdCubit.editAdBody!.images[index].id, index);
                              setState(() {});
                            },
                          ),
                          onReorder: (oldIndex, newIndex) {
                            final int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
                            final dynamic image = editAdCubit.editAdBody!.images.removeAt(oldIndex);
                            editAdCubit.editAdBody!.images.insert(index, image);
                          },
                        ),
                      ),
                    ),
              editAdCubit.editAdBody!.images.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(AppPadding.p8.w),
                      child: CustomText(L10n.tr(context).uploadImagesHint, fontSize: FontSize.s12),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      },
    );
  }
}

class _AdImage extends StatelessWidget {
  final dynamic image;
  final VoidCallback onDelete;

  const _AdImage({
    required this.image,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAdCubit, EditAdStates>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSize.s4.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s8.r),
                child: image is AdImage
                    ? Image.network(image.image, width: AppSize.s100.w, height: AppSize.s100.w, fit: BoxFit.cover)
                    : Image.file(image, width: AppSize.s100.w, height: AppSize.s100.w, fit: BoxFit.cover),
              ),
              (image is AdImage && state is DeleteAdImageLoadingState && state.imageId == image.id)
                  ? Container(
                      height: AppSize.s100.w,
                      width: AppSize.s100.w,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppSize.s8.r),
                      ),
                    )
                  : const SizedBox.shrink(),
              (image is AdImage && state is DeleteAdImageLoadingState && state.imageId == image.id)
                  ? const LoadingSpinner()
                  : const SizedBox.shrink(),
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
      },
    );
  }
}
