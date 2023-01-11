import 'package:agar_online/core/enum/category_type.dart';
import '../../../core/services/error/failure.dart';
import '../models/base_category_model.dart';

abstract class CategoriesStates {
  final CategoryType categoryType;
  final List<BaseCategoryModel> items;

  CategoriesStates(this.items, this.categoryType);
}

class CategoriesInitialState extends CategoriesStates {
  CategoriesInitialState(super.items, super.categoryType);
}

class GetCategoriesLoadingState extends CategoriesStates {
  GetCategoriesLoadingState(super.items, super.categoryType);
}

class GetCategoriesSuccessState extends CategoriesStates {
  GetCategoriesSuccessState(super.items, super.categoryType);
}

class GetCategoriesFailureState extends CategoriesStates {
  final Failure failure;

  GetCategoriesFailureState(this.failure, super.items, super.categoryType);
}
