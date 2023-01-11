import 'dart:async';

import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/modules/home/models/home_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/home_repository.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeInitialState());

  late HomeData homeData;
  int sliderIndex = 0;
  PageController pageController = PageController();
  Timer? timer;

  void setSliderIndex(int index) {
    sliderIndex = index;
    emit(HomeSetSliderIndexState());
  }

  void animateTopSlider(int slidersLength) {
    timer = Timer.periodic(Time.t3000, (timer) {
      if (sliderIndex < slidersLength - 1) {
        sliderIndex++;
        pageController.animateToPage(sliderIndex, duration: Time.t700, curve: Curves.easeInOut);
      } else {
        sliderIndex = 0;
        pageController.jumpToPage(sliderIndex);
      }
    });
  }

  Future<void> getHomeData() async {
    emit(GetHomeDataLoadingState());
    final result = await _homeRepository.getHomeData();
    result.fold(
      (failure) => emit(GetHomeDataFailureState(failure)),
      (homeData) {
        this.homeData = homeData;
        emit(GetHomeDataSuccessState());
      },
    );
  }
}
