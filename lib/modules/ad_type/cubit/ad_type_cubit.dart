import 'package:agar_online/modules/ad_type/cubit/ad_type_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/ad_type_repository.dart';

class AdTypesCubit extends Cubit<AdTypesStates> {
  final AdTypesRepository _adTypesRepository;

  AdTypesCubit(this._adTypesRepository) : super(AdTypesInitialState([]));

  Future<void> getAdTypes(int categoryId) async {
    emit(GetAdTypesLoadingState([]));
    final result = await _adTypesRepository.getAdTypes(categoryId);
    result.fold(
      (failure) => emit(GetAdTypesFailureState(failure, [])),
      (adTypes) => emit(GetAdTypesSuccessState(adTypes)),
    );
  }
}
