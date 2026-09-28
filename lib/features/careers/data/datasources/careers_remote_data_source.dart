import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../domain/entities/career_answer.dart';
import '../models/career_model.dart';

abstract class CareersRemoteDataSource {
  Future<List<CareerModel>> getCareers();

  Future<void> applyToCareer({required int careerId, required Map<int, CareerAnswer> answers});
}

class CareersRemoteDataSourceImpl implements CareersRemoteDataSource {
  final Dio _dio;
  CareersRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CareerModel>> getCareers() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.careers,
        // The backend localizes title/description off this — the app is
        // English-only today, so this is a fixed default rather than a
        // real locale switch.
        options: Options(headers: {'Accept-Language': 'en'}),
      );
      final data = ApiResponseParser.unwrap(response) as List<dynamic>;
      return data.map((e) => CareerModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<void> applyToCareer({
    required int careerId,
    required Map<int, CareerAnswer> answers,
  }) async {
    try {
      final formData = FormData();
      for (final entry in answers.entries) {
        final key = 'answers[${entry.key}]';
        final answer = entry.value;
        if (answer.isFile) {
          formData.files.add(
            MapEntry(key, await MultipartFile.fromFile(answer.filePath!, filename: answer.fileName)),
          );
        } else if (answer.text != null) {
          formData.fields.add(MapEntry(key, answer.text!));
        }
      }

      final response = await _dio.post(ApiEndpoints.applyToCareer(careerId), data: formData);
      ApiResponseParser.unwrap(response);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
