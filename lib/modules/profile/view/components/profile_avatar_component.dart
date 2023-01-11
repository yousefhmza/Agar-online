import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/pickers.dart';
import '../../../../core/view/components/pick_image_sheet_component.dart';
import '../../cubits/profile_cubit.dart';
import '../../cubits/profile_states.dart';
import '../../models/body/profile_body.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/globals.dart';
import '../../../../core/view/app_views.dart';

class ProfileAvatarComponent extends StatelessWidget {
  final ProfileBody profileBody;

  const ProfileAvatarComponent({required this.profileBody, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
    return InkWell(
      onTap: () => Alerts.showBottomSheet(
        context,
        expandable: false,
        child: PickImageSheetComponent(
          onGallery: () async {
            final File? image = await Pickers.pickImage(ImageSource.gallery);
            if (image != null) profileCubit.pickProfileImage(profileBody, image);
          },
          onCamera: () async {
            final File? image = await Pickers.pickImage(ImageSource.camera);
            if (image != null) profileCubit.pickProfileImage(profileBody, image);
          },
        ),
      ),
      customBorder: const CircleBorder(),
      child: SizedBox(
        height: deviceWidth * 0.25,
        width: deviceWidth * 0.25,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s100.r),
              child: BlocBuilder<ProfileCubit, ProfileStates>(
                buildWhen: (prevState, state) => state is SetProfileFieldValueState,
                builder: (context, state) {
                  return profileBody.avatar == null
                      ? CustomNetworkImage(
                          image: currentUser!.avatar,
                          height: deviceWidth * 0.25,
                          width: deviceWidth * 0.25,
                        )
                      : Image.file(
                          profileBody.avatar!,
                          fit: BoxFit.cover,
                          height: deviceWidth * 0.25,
                          width: deviceWidth * 0.25,
                        );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppPadding.p4.w),
              decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: const CustomIcon(Icons.camera_alt, color: AppColors.primaryRed, size: AppSize.s18),
            )
          ],
        ),
      ),
    );
  }
}
