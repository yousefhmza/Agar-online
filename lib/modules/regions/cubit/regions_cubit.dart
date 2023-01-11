import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/region_type.dart';
import '../repositories/regions_repository.dart';
import 'regions_states.dart';

class RegionsCubit extends Cubit<RegionsStates> {
  final RegionsRepository _regionsRepository;

  RegionsCubit(this._regionsRepository) : super(RegionsInitialState([], RegionType.none));

  Future<void> getCities() async {
    emit(GetRegionLoadingState([], RegionType.city));
    final result = await _regionsRepository.getCities();
    result.fold(
      (failure) => emit(GetRegionFailureState(failure, [], RegionType.city)),
      (cities) => emit(GetRegionSuccessState(cities, RegionType.city)),
    );
  }

  Future<void> getCityAreas(int cityId) async {
    emit(GetRegionLoadingState([], RegionType.cityArea));
    final result = await _regionsRepository.getCityAreas(cityId);
    result.fold(
      (failure) => emit(GetRegionFailureState(failure, [], RegionType.cityArea)),
      (cityAreas) => emit(GetRegionSuccessState(cityAreas, RegionType.cityArea)),
    );
  }

  Future<void> getSubAreas(int areaId) async {
    emit(GetRegionLoadingState([], RegionType.subArea));
    final result = await _regionsRepository.getSubAreas(areaId);
    result.fold(
      (failure) => emit(GetRegionFailureState(failure, [], RegionType.subArea)),
      (subAreas) => emit(GetRegionSuccessState(subAreas, RegionType.subArea)),
    );
  }

  void resetCities() => emit(GetRegionSuccessState([], RegionType.city));

  void resetAreas() => emit(GetRegionSuccessState([], RegionType.cityArea));

  void resetSubAreas() => emit(GetRegionSuccessState([], RegionType.subArea));
}
