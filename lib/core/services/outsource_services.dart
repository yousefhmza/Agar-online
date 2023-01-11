import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agar_online/core/utils/globals.dart';
import '../../config/localization/l10n/l10n.dart';
import '../utils/alerts.dart';

class OutsourceServices {
  static Future<void> share(String url) async {
    return await Share.share(url);
  }

  static Future<void> launch(String url) async {
    final Uri link = Uri.parse(url);
    final bool canLaunch = await canLaunchUrl(link);
    if (canLaunch) {
      await launchUrl(link, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      Alerts.showToast(L10n.tr(globalContext).cantLaunchUrl);
    }
  }
}
