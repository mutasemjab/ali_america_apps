import 'client_model.dart';

class VerifyOtpResponseModel {
  final String token;
  final ClientModel client;

  const VerifyOtpResponseModel({required this.token, required this.client});

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      token: json['token']?.toString() ?? '',
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
    );
  }
}
