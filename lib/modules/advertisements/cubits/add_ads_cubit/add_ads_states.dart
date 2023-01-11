import 'package:agar_online/modules/advertisements/models/response/setting_model.dart';
import '../../../../core/services/error/failure.dart';

abstract class AddAdsStates {}

class AddAdsInitialState extends AddAdsStates {}

class AddAdLoadingState extends AddAdsStates {}

class AddAdSuccessState extends AddAdsStates {
  final String message;

  AddAdSuccessState(this.message);
}

class AddAdFailureState extends AddAdsStates {
  final Failure failure;

  AddAdFailureState(this.failure);
}

class GetAdSettingsSuccessState extends AddAdsStates {
  final SettingModel settingModel;

  GetAdSettingsSuccessState(this.settingModel);
}

class GetAdSettingsFailureState extends AddAdsStates {
  final Failure failure;

  GetAdSettingsFailureState(this.failure);
}
