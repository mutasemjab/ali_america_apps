import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../domain/entities/legal_document_type.dart';
import '../models/legal_document_model.dart';

abstract class LegalDocumentRemoteDataSource {
  Future<LegalDocumentModel> getLegalDocument(String type);
}

class LegalDocumentRemoteDataSourceImpl implements LegalDocumentRemoteDataSource {
  final Dio _dio;
  LegalDocumentRemoteDataSourceImpl(this._dio);

  @override
  Future<LegalDocumentModel> getLegalDocument(String type) async {
    try {
      // The client app's own privacy policy is separate content on its own
      // endpoint — not the tablet kiosk's, which stays on /legal-document.
      final response = type == LegalDocumentType.privacyPolicy
          ? await _dio.get(ApiEndpoints.clientPrivacyPolicy)
          : await _dio.get(ApiEndpoints.legalDocument, queryParameters: {'type': type});
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return LegalDocumentModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
