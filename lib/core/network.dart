import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';

import '../utils/config.dart';
import '../res/strings.dart';
import 'core.dart';

final networkRepoProvider = StateProvider((ref) {
  return NetworkRepo();
});

class NetworkRepo {
  NetworkRepo();

  String queryParameters(Map<String, String?>? params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }

  FutureEither<Response> getRequest({
    required String url,
    bool requireAuth = true,
    String? token,
    Map<String, String>? params,
    int maxRetries = 3,
    Duration timeoutDuration = const Duration(seconds: 10),
  }) async {
    final uri = url + ((params != null) ? queryParameters(params) : '');

    final Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };

    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await get(Uri.parse(uri), headers: requestHeaders);
        log('RESPONSE : ${response.body}', name: LogLabel.httpGet);
        if (response.statusCode != 200) {
          return Left(Failure(
            message: 'Request failed with status code ${response.statusCode}',
            stackTrace: StackTrace.current,
          ));
        }
        return Right(response);
      } on TimeoutException catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          if (AppConfig.logHttp) {
            log('Timeout error after $retryCount retries',
                name: LogLabel.httpGet);
          }
          return Left(Failure(
            message: 'Request timed out',
            stackTrace: StackTrace.current,
          ));
        }
      } on ClientException catch (e, stktrc) {
        if (AppConfig.logHttp) {
          log('ClientException: ${e.message}', name: LogLabel.httpGet);
        }
        return Left(
            Failure(message: 'Client error: ${e.message}', stackTrace: stktrc));
      } catch (e, stktrc) {
        if (AppConfig.logHttp) {
          log('Unhandled Exception: $e', name: LogLabel.httpGet);
        }
        return Left(Failure(
            message: FailureMessage.getRequestMessage, stackTrace: stktrc));
      }
    }

    return Left(Failure(
        message: 'Request failed after $maxRetries retries',
        stackTrace: StackTrace.current));
  }
}
