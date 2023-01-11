import 'package:dartz/dartz.dart';

import '../../../core/services/error/error_handler.dart';
import 'package:agar_online/modules/categories/models/sub_sub_category_model.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/services/network/api_consumer.dart';
import '../../../core/services/network/endpoints.dart';
import '../../../core/services/network/network_info.dart';
import '../models/category_model.dart';
import '../models/sub_category_model.dart';

class CategoriesRepository {
  final ApiConsumer _apiConsumer;
  final NetworkInfo _networkInfo;

  CategoriesRepository(this._apiConsumer, this._networkInfo);

  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(url: EndPoints.getAllCategories);
        return Right(
          List<CategoryModel>.from(response.data["data"].map((category) => CategoryModel.fromJson(category))),
        );
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<Subcategory>>> getSubcategories(int categoryId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(
          url: EndPoints.getSubcategories,
          queryParameters: {"category": categoryId},
        );
        return Right(
          List<Subcategory>.from(response.data["data"].map((subcategory) => Subcategory.fromJson(subcategory))),
        );
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }

  Future<Either<Failure, List<SubSubCategory>>> getSubSubCategories(int subCategoryId) async {
    final bool hasConnection = await _networkInfo.hasConnection;
    if (hasConnection) {
      try {
        final response = await _apiConsumer.get(
          url: EndPoints.getSubSubCategories,
          queryParameters: {"sub_category": subCategoryId},
        );
        return Right(
          List<SubSubCategory>.from(response.data["data"].map((subSubCat) => SubSubCategory.fromJson(subSubCat))),
        );
      } on Exception catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(ErrorType.noInternetConnection.getFailure());
    }
  }
}
