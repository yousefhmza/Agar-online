import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/enum/category_type.dart';
import '../models/category_model.dart';
import '../repositories/categories_repository.dart';
import 'categories_states.dart';

class CategoriesCubit extends Cubit<CategoriesStates> {
  final CategoriesRepository _categoriesRepository;

  CategoriesCubit(this._categoriesRepository) : super(CategoriesInitialState([], CategoryType.none));

  List<CategoryModel> categories = [];

  Future<void> getAllCategories() async {
    emit(GetCategoriesLoadingState([], CategoryType.category));
    final result = await _categoriesRepository.getAllCategories();
    result.fold(
      (failure) => emit(GetCategoriesFailureState(failure, [], CategoryType.category)),
      (categories) {
        this.categories = categories;
        emit(GetCategoriesSuccessState(categories, CategoryType.category));
      },
    );
  }

  Future<void> getSubcategories(int categoryId) async {
    emit(GetCategoriesLoadingState([], CategoryType.subCategory));
    final result = await _categoriesRepository.getSubcategories(categoryId);
    result.fold(
      (failure) => emit(GetCategoriesFailureState(failure, [], CategoryType.subCategory)),
      (subCategories) => emit(GetCategoriesSuccessState(subCategories, CategoryType.subCategory)),
    );
  }

  Future<void> getSubSubcategories(int subCategoryId) async {
    emit(GetCategoriesLoadingState([], CategoryType.subSubCategory));
    final result = await _categoriesRepository.getSubSubCategories(subCategoryId);
    result.fold(
      (failure) => emit(GetCategoriesFailureState(failure, [], CategoryType.subSubCategory)),
      (subSubCategories) => emit(GetCategoriesSuccessState(subSubCategories, CategoryType.subSubCategory)),
    );
  }

  void resetCategories() => emit(GetCategoriesSuccessState([], CategoryType.category));

  void resetSubCategories() => emit(GetCategoriesSuccessState([], CategoryType.subCategory));

  void resetSubSubCategories() => emit(GetCategoriesSuccessState([], CategoryType.subSubCategory));
}
