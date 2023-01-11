import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/localization/l10n/l10n.dart';
import '../../config/routing/navigation_service.dart';
import '../../config/routing/routes.dart';
import '../../modules/auth/models/response/user_model.dart';
import '../../modules/splash/cubit/splash_cubit.dart';
import 'alerts.dart';

User? currentUser;
final BuildContext globalContext = NavigationService.navigationKey.currentContext!;

invokeIfAuthenticated(BuildContext context, {required Function callback, Function? beforeAuthCallback}) {
  if (BlocProvider.of<SplashCubit>(context).isAuthed) {
    callback();
  } else {
    Alerts.showAppDialog(
      context,
      title: L10n.tr(context).loginFirst,
      confirmText: L10n.tr(context).login,
      onConfirm: () {
        if (beforeAuthCallback != null) beforeAuthCallback();
        NavigationService.push(context, Routes.loginScreen);
      },
    );
  }
}

final String clientId = Platform.isAndroid ? "" : "";
