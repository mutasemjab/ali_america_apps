import 'package:equatable/equatable.dart';

import '../../domain/entities/social_entity.dart';

enum SocialsStatus { loading, loaded, error }

class SocialsState extends Equatable {
  final SocialsStatus status;
  final List<SocialEntity> socials;
  final String? errorMessage;

  const SocialsState({this.status = SocialsStatus.loading, this.socials = const [], this.errorMessage});

  @override
  List<Object?> get props => [status, socials, errorMessage];
}
