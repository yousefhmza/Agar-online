import 'package:agar_online/core/services/error/failure.dart';

import '../model/ad_type_model.dart';

abstract class AdTypesStates {
  final List<AdType> adTypes;

  AdTypesStates(this.adTypes);
}

class AdTypesInitialState extends AdTypesStates {
  AdTypesInitialState(super.adTypes);
}

class GetAdTypesLoadingState extends AdTypesStates {
  GetAdTypesLoadingState(super.adTypes);
}

class GetAdTypesFailureState extends AdTypesStates {
  final Failure failure;

  GetAdTypesFailureState(this.failure, super.adTypes);
}

class GetAdTypesSuccessState extends AdTypesStates {
  GetAdTypesSuccessState(super.adTypes);
}
