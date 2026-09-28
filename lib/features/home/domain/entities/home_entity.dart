import 'package:equatable/equatable.dart';

import 'banner_entity.dart';
import 'home_icons_entity.dart';
import 'store_entity.dart';

class HomeEntity extends Equatable {
  final StoreEntity store;
  final List<BannerEntity> banners;
  final HomeIconsEntity icons;

  const HomeEntity({required this.store, required this.banners, this.icons = const HomeIconsEntity()});

  @override
  List<Object?> get props => [store, banners, icons];
}
