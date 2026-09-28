import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/client.dart';

enum ProfileStatus { loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final Client? client;
  final String? errorMessage;
  final bool saving;
  final bool deleting;
  final bool loggingOut;
  final String? actionError;

  const ProfileState({
    this.status = ProfileStatus.loading,
    this.client,
    this.errorMessage,
    this.saving = false,
    this.deleting = false,
    this.loggingOut = false,
    this.actionError,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    Client? client,
    String? errorMessage,
    bool? saving,
    bool? deleting,
    bool? loggingOut,
    String? actionError,
  }) {
    return ProfileState(
      status: status ?? this.status,
      client: client ?? this.client,
      errorMessage: errorMessage,
      saving: saving ?? this.saving,
      deleting: deleting ?? this.deleting,
      loggingOut: loggingOut ?? this.loggingOut,
      actionError: actionError,
    );
  }

  @override
  List<Object?> get props =>
      [status, client, errorMessage, saving, deleting, loggingOut, actionError];
}
