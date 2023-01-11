import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_states.dart';
import '../repository/search_repository.dart';
import '../models/body/search_params_body.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepository _searchRepository;

  SearchCubit(this._searchRepository) : super(SearchInitialState());

  late SearchParamsBody searchParamsBody;

  void initSearchState() => emit(SearchInitialState());

  Future<void> getSearch() async {
    emit(GetSearchLoadingState());
    final result = await _searchRepository.getSearch(searchParamsBody);
    result.fold(
      (failure) => emit(GetSearchFailureState(failure)),
      (ads) => emit(GetSearchSuccessState(ads)),
    );
  }
}
