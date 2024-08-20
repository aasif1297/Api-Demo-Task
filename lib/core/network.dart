import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';

import '../utils/config.dart';
import '../res/strings.dart';
import 'core.dart';
import 'hive_cache_manager.dart';

final networkRepoProvider = StateProvider((ref) {
  return NetworkRepo();
});

class NetworkRepo {
  NetworkRepo();

  final HiveCache cache = HiveCache();

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

    // Check if the response is in the cache
    final cachedData = cache.get(uri);
    if (cachedData != null) {
      if (cachedData.eTag != null) {
        requestHeaders["If-None-Match"] = cachedData.eTag!;
      } else if (cachedData.lastModified != null) {
        requestHeaders["If-Modified-Since"] = cachedData.lastModified!;
      }

      // Check internet connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection and no cached data, return an error
        return Right(cachedData.toHttpResponse());
      }
    }

    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await get(Uri.parse(uri), headers: requestHeaders)
            .timeout(timeoutDuration);

        log('RESPONSE : ${response.body}', name: LogLabel.httpGet);
        if (response.statusCode == 304 && cachedData != null) {
          // Data hasn't changed; return the cached data
          log('CACHE HIT: Server returned 304 Not Modified for $uri',
              name: LogLabel.httpGet);
          return Right(cachedData.toHttpResponse());
        } else if (response.statusCode == 200) {
          // Data has changed; update the cache
          cache.set(uri, response);
          return Right(response);
        } else {
          return Left(Failure(
              message: 'Unexpected status code: ${response.statusCode}',
              stackTrace: StackTrace.current));
        }
      } on TimeoutException {
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
