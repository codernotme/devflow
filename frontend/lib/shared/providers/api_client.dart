import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Typically this would come from an environment variable via String.fromEnvironment
const String baseUrl = 'http://localhost:8000';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors here if needed (e.g. logging)
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return dio;
});
