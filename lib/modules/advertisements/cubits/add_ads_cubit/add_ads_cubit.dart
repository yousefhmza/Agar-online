import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../repositories/ad_form_repository.dart';
import '../../models/body/add_ad_body.dart';
import 'add_ads_states.dart';

class AddAdsCubit extends Cubit<AddAdsStates> {
  final AdFormRepository _adFormRepository;

  AddAdsCubit(this._adFormRepository) : super(AddAdsInitialState());

  AddAdBody addAdBody = AddAdBody(images: []);

  Future<void> addAd(BuildContext context) async {
    emit(AddAdLoadingState());
    final result = await _adFormRepository.addAd(context, addAdBody);
    result.fold(
      (failure) => emit(AddAdFailureState(failure)),
      (message) {
        if (addAdBody.isFeatured) getAdSetting();
        emit(AddAdSuccessState(message));
      },
    );
  }

  Future<void> getAdSetting() async {
    final result = await _adFormRepository.getSetting();
    result.fold(
      (failure) => emit(GetAdSettingsFailureState(failure)),
      (settingModel) => emit(GetAdSettingsSuccessState(settingModel)),
    );
  }

  void resetValues() => addAdBody.resetValues();
}
