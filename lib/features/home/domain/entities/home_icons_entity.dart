import 'package:equatable/equatable.dart';

/// Per-store toggles for the home screen's icon grid — each store can turn
/// any of these off from their admin panel. Missing/omitted flags default
/// to visible so older backend responses don't suddenly hide everything.
class HomeIconsEntity extends Equatable {
  final bool inStoreDeals;
  final bool social;
  final bool qr;
  final bool weeklyAds;
  final bool coupons;
  final bool location;
  final bool rewards;

  const HomeIconsEntity({
    this.inStoreDeals = true,
    this.social = true,
    this.qr = true,
    this.weeklyAds = true,
    this.coupons = true,
    this.location = true,
    this.rewards = true,
  });

  @override
  List<Object?> get props => [inStoreDeals, social, qr, weeklyAds, coupons, location, rewards];
}
