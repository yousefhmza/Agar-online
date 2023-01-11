import 'package:agar_online/core/utils/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ad_image_model.dart';
import '../../../favourites/cubits/favourites_cubit.dart';
import '../../../../core/utils/globals.dart';
import '../../../../core/extensions/non_null_extensions.dart';
import '../../../categories/models/category_model.dart';
import '../../../../core/utils/constants.dart';
import '../../../regions/models/city_area_model.dart';
import '../../../regions/models/city_model.dart';
import 'ad_owner_model.dart';
import '../../../ad_type/model/ad_type_model.dart';

class Advertisement {
  final int id;
  final String name;
  final String description;
  final int price;
  final bool blocked;
  final String image;
  final CategoryModel category;
  final int subCategory;
  final int subSubCategory;
  final City city;
  final Area cityArea;
  final int cityId;
  final int areaId;
  final int? subareaId;
  final List<AdImage> images;
  final DateTime createdAt;
  final int contactMethod;
  final bool canContactByPhone;
  final bool canContactByChat;
  final AdOwner adOwner;
  final bool isApproved;
  final AdType adType;
  final bool isFeatured;
  final String address;
  bool isFavourite;
  final List<Advertisement> similarAds;

  Advertisement({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.blocked,
    required this.image,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    required this.city,
    required this.cityArea,
    required this.cityId,
    required this.areaId,
    required this.subareaId,
    required this.images,
    required this.createdAt,
    required this.contactMethod,
    required this.canContactByChat,
    required this.canContactByPhone,
    required this.adOwner,
    required this.isApproved,
    required this.adType,
    required this.isFeatured,
    required this.address,
    required this.isFavourite,
    required this.similarAds,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        price: double.tryParse(json["price"]).orZero.round(),
        blocked: json["block"] == "true",
        image: Constants.imagesBaseUrl + json["plan"].toString(),
        category: CategoryModel.fromJson(json["type"] ?? {}),
        subCategory: json["sub_main_Cat"] ?? 1,
        subSubCategory: json["sub_Cat"] ?? 1,
        city: City.fromJson(json["city"] ?? {}),
        cityArea: Area.fromJson(json["city_area"] ?? {}),
        cityId: json["city_id"] ?? 0,
        areaId: json["area_id"] ?? 0,
        subareaId: json["subarea_id"] ?? 0,
        images: json["images"] != null ? List<AdImage>.from(json["images"].map((img) => AdImage.fromJson(img))) : [],
        createdAt: DateTime.tryParse(json["created_at"].toString()) ?? DateTime.now(),
        contactMethod: json["contact"] ?? 0,
        canContactByChat: json["contact"] == 1 || json["contact"] == 3,
        canContactByPhone: json["contact"] == 2 || json["contact"] == 3,
        adOwner: AdOwner.fromJson(json["owner"] ?? {}),
        isApproved: json["is_approved"] == 1 ? true : false,
        adType: AdType.fromJson(json["ad_for"] ?? {}),
        isFeatured: json["is_special"] == 1 ? true : false,
        address: json["address"] ?? "",
        isFavourite: BlocProvider.of<FavouritesCubit>(globalContext).favouriteAds != null
            ? BlocProvider.of<FavouritesCubit>(globalContext)
                .favouriteAds!
                .map((ad) => ad.id)
                .toList()
                .contains(json["id"])
            : false,
        similarAds: Helpers.getNotBlockedAds(json["similar"] ?? []),
      );
}
