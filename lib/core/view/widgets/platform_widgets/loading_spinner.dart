import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../extensions/num_extensions.dart';
import '../../../resources/values_manager.dart';
import 'base_platform_widget.dart';

class LoadingSpinner extends BasePlatformWidget<Center, Center> {
  final bool hasSmallRadius;
  final double _radius;
  final double _strokeWidth;
  final Color? color;

  const LoadingSpinner({this.hasSmallRadius = false, this.color, Key? key})
      : _radius = hasSmallRadius ? AppSize.s12 : AppSize.s24,
        _strokeWidth = hasSmallRadius ? AppSize.s2 : AppSize.s3,
        super(key: key);

  @override
  Center createCupertinoWidget(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(radius: AppSize.s12.r, color: color));
  }

  @override
  Center createMaterialWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        height: _radius.r,
        width: _radius.r,
        child: CircularProgressIndicator(strokeWidth: _strokeWidth.w, color: color),
      ),
    );
  }
}
