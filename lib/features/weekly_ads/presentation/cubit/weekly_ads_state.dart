import 'package:equatable/equatable.dart';

import '../../domain/entities/weekly_ad_entity.dart';

enum WeeklyAdsStatus { loading, loaded, error }

class WeeklyAdsState extends Equatable {
  final WeeklyAdsStatus status;
  final List<WeeklyAdEntity> ads;
  final String? errorMessage;

  const WeeklyAdsState({this.status = WeeklyAdsStatus.loading, this.ads = const [], this.errorMessage});

  @override
  List<Object?> get props => [status, ads, errorMessage];
}
