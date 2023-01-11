import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/response/advertisement_model.dart';
import '../../repositories/ad_form_repository.dart';
import '../../models/body/edit_ad_body.dart';
import 'edit_ad_states.dart';

class EditAdCubit extends Cubit<EditAdStates> {
  final AdFormRepository _adFormRepository;

  EditAdCubit(this._adFormRepository) : super(EditAdInitialState());

  EditAdBody? editAdBody;

  Future<void> editAdd(BuildContext context) async {
    emit(EditAdLoadingState());
    final result = await _adFormRepository.editAd(context, editAdBody!);
    result.fold(
      (failure) => emit(EditAdFailureState(failure)),
      (message) => emit(EditAdSuccessState(message)),
    );
  }

  Future<void> deleteAdImage(int imageId, int index) async {
    emit(DeleteAdImageLoadingState(imageId));
    final result = await _adFormRepository.deleteAdImage(imageId);
    result.fold(
      (failure) => emit(DeleteAdImageFailureState(failure)),
      (message) {
        editAdBody!.images.removeAt(index);
        emit(DeleteAdImageSuccessState());
      },
    );
  }

  void assignEditAdBody(Advertisement ad) {
    editAdBody = EditAdBody(
      id: ad.id,
      name: ad.name,
      desc: ad.description,
      categoryId: ad.category.id,
      subCategoryId: ad.subCategory,
      subSubCategoryId: ad.subSubCategory,
      adTypeId: ad.adType.id,
      price: ad.price.toString(),
      contact: ad.contactMethod,
      isFeatured: ad.isFeatured,
      cityId: ad.cityId,
      areaId: ad.areaId,
      subAreaId: ad.subareaId,
      address: ad.address,
      images: List<dynamic>.from(ad.images.map((image) => image)).toList(),
    );
  }
}
