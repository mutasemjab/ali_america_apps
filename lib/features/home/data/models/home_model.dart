import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/home_icons_entity.dart';
import '../../domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  const StoreModel({
    required super.id,
    required super.name,
    super.logo,
    super.phone,
    super.facebookLink,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      logo: json['logo']?.toString(),
      phone: json['phone']?.toString(),
      facebookLink: json['facebook_link']?.toString(),
    );
  }
}

class BannerModel extends BannerEntity {
  const BannerModel({required super.id, required super.image});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(id: json['id'] as int, image: json['image']?.toString() ?? '');
  }
}

class HomeIconsModel extends HomeIconsEntity {
  const HomeIconsModel({
    super.inStoreDeals,
    super.social,
    super.qr,
    super.weeklyAds,
    super.coupons,
    super.location,
    super.rewards,
  });

  factory HomeIconsModel.fromJson(Map<String, dynamic>? json) {
    bool flag(String key, bool fallback) => (json?[key] as bool?) ?? fallback;
    return HomeIconsModel(
      inStoreDeals: flag('in_store_deals', true),
      social: flag('social', true),
      qr: flag('qr', true),
      weeklyAds: flag('weekly_ads', true),
      coupons: flag('coupons', true),
      location: flag('location', true),
      rewards: flag('rewards', true),
    );
  }
}

class HomeModel extends HomeEntity {
  const HomeModel({required super.store, required super.banners, required super.icons});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final bannersJson = json['banners'] as List<dynamic>? ?? [];
    return HomeModel(
      store: StoreModel.fromJson(json['store'] as Map<String, dynamic>),
      banners: bannersJson
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      icons: HomeIconsModel.fromJson(json['icons'] as Map<String, dynamic>?),
    );
  }
}
