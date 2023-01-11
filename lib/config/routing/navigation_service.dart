import 'package:flutter/widgets.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static Future<dynamic> push(BuildContext context, String route, {Map<String, dynamic>? arguments}) async {
    return await Navigator.pushNamed(context, route, arguments: arguments);
  }

  static Future<dynamic> pushReplacement(BuildContext context, String route, {Map<String, dynamic>? arguments}) async {
    return await Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  static Future<dynamic> pushReplacementAll(
    BuildContext context,
    String route, {
    Map<String, dynamic>? arguments,
  }) async {
    return await Navigator.pushNamedAndRemoveUntil(context, route, (route) => false, arguments: arguments);
  }

  static dynamic goBack(BuildContext context, [Object? result]) {
    return Navigator.pop(context, result);
  }
}
