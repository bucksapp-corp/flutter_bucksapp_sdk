library flutter_bucksapp_sdk;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class Bucksapp extends StatefulWidget {
  const Bucksapp({
    Key? key,
    required this.apiKey,
    required this.uuid,
  }) : super(key: key);

  final String apiKey;
  final String uuid;

  @override
  State<Bucksapp> createState() => _BucksappState();
}

class _BucksappState extends State<Bucksapp> {
  late InAppWebViewController webView;
  final CookieManager cookieManager = CookieManager.instance();

  Future<String?> getToken() async {
    final response = await http.post(
        Uri.parse('https://api.dev.bucksapp.com/api/fi/v1/authenticate'),
        headers: {
          'jwt_aud': 'development',
          'Content-Type': 'application/json',
          'X-API-KEY': widget.apiKey
        },
        body: json.encode({"user": widget.uuid}));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)?["token"];
    } else {
      return response.reasonPhrase;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            cookieManager.setCookie(
                url: Uri.parse('https://app.dev.bucksapp.com'),
                name: "token",
                value: snapshot.data!);
            cookieManager.setCookie(
                url: Uri.parse('https://app.dev.bucksapp.com'),
                name: "NEXT_LOCALE",
                value: "es");

            return InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(useHybridComposition: true),
              ),
              initialUrlRequest: URLRequest(
                url: Uri.parse('https://app.dev.bucksapp.com'),
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
