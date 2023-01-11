import '../../resources/app_resources.dart';
import 'package:flutter/material.dart';
import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import '../app_views.dart';

class PickImageSheetComponent extends StatelessWidget {
  final Future<void> Function() onGallery;
  final Future<void> Function() onCamera;

  const PickImageSheetComponent(
      {required this.onGallery, required this.onCamera, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () async {
            await onGallery();
            // ignore: use_build_context_synchronously
            NavigationService.goBack(context);
          },
          horizontalTitleGap: AppSize.s0,
          leading: const CustomIcon(Icons.image, color: AppColors.black),
          title: CustomText(L10n.tr(context).gallery),
        ),
        ListTile(
          onTap: () async {
            await onCamera();
            // ignore: use_build_context_synchronously
            NavigationService.goBack(context);
          },
          horizontalTitleGap: AppSize.s0,
          leading: const CustomIcon(Icons.camera_alt, color: AppColors.black),
          title: CustomText(L10n.tr(context).camera),
        ),
        ListTile(
          onTap: () => NavigationService.goBack(context),
          horizontalTitleGap: AppSize.s0,
          leading: const CustomIcon(Icons.cancel, color: AppColors.black),
          title: CustomText(L10n.tr(context).cancel),
        ),
      ],
    );
  }
}
