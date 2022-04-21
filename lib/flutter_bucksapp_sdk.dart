library flutter_bucksapp_sdk;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bucksapp_sdk/helpers.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class Bucksapp extends StatefulWidget {
  const Bucksapp({
    Key? key,
    required this.apiKey,
    required this.uuid,
    required this.environment,
  }) : super(key: key);

  final String apiKey;
  final String uuid;
  final String environment;

  @override
  State<Bucksapp> createState() => _BucksappState();
}

class _BucksappState extends State<Bucksapp> {
  late InAppWebViewController webView;
  final CookieManager cookieManager = CookieManager.instance();

  Future<String?> getToken() async {
    Uri uri;
    switch (widget.environment) {
      case 'staging':
        uri = Uri.parse('https://api.stg.bucksapp.com/api/fi/v1/authenticate');
        break;
      case 'production':
        uri = Uri.parse('https://api.prd.bucksapp.com/api/fi/v1/authenticate');
        break;
      default:
        uri = Uri.parse('https://api.dev.bucksapp.com/api/fi/v1/authenticate');
        break;
    }

    final response = await http.post(uri,
        headers: {
          'jwt_aud': widget.environment,
          'Content-Type': 'application/json',
          'X-API-KEY': widget.apiKey,
          'platform': defaultTargetPlatform.name,
        },
        body: json.encode({"user": widget.uuid}));

    logResponse(response);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)?["token"];
    } else {
      return response.reasonPhrase;
    }
  }

  @override
  Widget build(BuildContext context) {
    Uri uriApp;
    switch (widget.environment) {
      case 'staging':
        uriApp = Uri.parse('https://app.stg.bucksapp.com');
        break;
      case 'production':
        uriApp = Uri.parse('https://app.prd.bucksapp.com');
        break;
      default:
        uriApp = Uri.parse('https://app.dev.bucksapp.com');
        break;
    }
    return FutureBuilder<String?>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            cookieManager.setCookie(
                url: uriApp,
                name: "token",
                value: snapshot.data!);
            cookieManager.setCookie(
                url: uriApp,
                name: "NEXT_LOCALE",
                value: "es");

            return InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(useHybridComposition: true),
              ),
              initialUrlRequest: URLRequest(
                url: uriApp,
                method: 'GET',
                headers: {
                  HttpHeaders.authorizationHeader: 'Bearer ${snapshot.data}'
                },
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                controller.addJavaScriptHandler(
                    handlerName: 'handlerBack',
                    callback: (args) {
                      Navigator.of(context).pop();
                    });
                webView = controller;
              },
            );
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        });
  }
}
