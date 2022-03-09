import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

void logResponse(response) => kDebugMode
    ? Logger().d([
        response.request.toString(),
        response.request.url.path,
        "REQUEST:",
        response.request.headers,
        json.decode(response.request.body),
        "RESPONSE:",
        response.statusCode,
        json.decode(response.body)
      ])
    : null;

void log(message) => kDebugMode ? Logger().d(message) : null;

void logError(message) => kDebugMode ? Logger().e(message) : null;
