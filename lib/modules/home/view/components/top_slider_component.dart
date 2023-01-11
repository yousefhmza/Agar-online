import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/modules/home/cubits/home_cubit.dart';
import 'package:agar_online/modules/home/cubits/home_states.dart';
import 'package:agar_online/modules/home/view/widgets/slider_indicator.dart';
import '../../../../core/resources/app_resources.dart';
import '../../models/slider_model.dart';
import '../widgets/slider_item.dart';

class TopSliderComponent extends StatefulWidget {
  final List<SliderModel> sliders;

  const TopSliderComponent(this.sliders, {Key? key}) : super(key: key);

  @override
  State<TopSliderComponent> createState() => _TopSliderComponentState();
}

class _TopSliderComponentState extends State<TopSliderComponent> {
  late final HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.animateTopSlider(widget.sliders.length);
    super.initState();
  }

  @override
  void dispose() {
    homeCubit.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight * 0.24,
      width: deviceWidth,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.sliders.length,
            controller: homeCubit.pageController,
            onPageChanged: homeCubit.setSliderIndex,
            itemBuilder: (context, index) => SliderItem(widget.sliders[index]),
          ),
          BlocBuilder<HomeCubit, HomeStates>(
            buildWhen: (prevState, state) => state is HomeSetSliderIndexState,
            builder: (context, index) => Positioned(
              left: AppSize.s0,
              right: AppSize.s0,
              bottom: AppSize.s20.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.sliders.length,
                  (index) => SliderIndicator(isCurrent: index == homeCubit.sliderIndex),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
