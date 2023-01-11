import '../models/region_model.dart';

import '../../../core/enum/region_type.dart';
import '../../../core/services/error/failure.dart';

abstract class RegionsStates {
  final RegionType regionType;
  final List<RegionModel> regions;

  RegionsStates(this.regions, this.regionType);
}

class RegionsInitialState extends RegionsStates {
  RegionsInitialState(super.regions, super.regionType);
}

class GetRegionLoadingState extends RegionsStates {
  GetRegionLoadingState(super.regions, super.regionType);
}

class GetRegionSuccessState extends RegionsStates {
  GetRegionSuccessState(super.regions, super.regionType);
}

class GetRegionFailureState extends RegionsStates {
  final Failure failure;

  GetRegionFailureState(this.failure, super.regions, super.regionType);
}
