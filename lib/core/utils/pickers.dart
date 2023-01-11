import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import '../../config/localization/l10n/l10n.dart';
import '../../config/routing/navigation_service.dart';

import 'alerts.dart';

class Pickers {
  static Future<File?> pickImage(ImageSource imageSource) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: imageSource);
      return image != null ? File(image.path) : null;
    } on PlatformException catch (_) {
      Alerts.showToast(
          L10n.tr(NavigationService.navigationKey.currentContext!).unKnown);
      return null;
    }
  }

  static Future<List<File>> pickMultiImages() async {
    try {
      final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
      if (selectedImages == null) return [];
      final List<File> images = [];
      for (var image in selectedImages) {
        images.add(File(image.path));
      }
      return images;
    } on PlatformException catch (_) {
      Alerts.showToast(
          L10n.tr(NavigationService.navigationKey.currentContext!).unKnown);
      return [];
    }
  }
}
