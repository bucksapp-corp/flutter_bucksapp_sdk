import 'dart:io';
import 'package:example/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bucksapp_sdk/flutter_bucksapp_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          return null;
        },
      );
    }
  }

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      theme: ThemeData(
          primarySwatch: const MaterialColor(0xFF2C5597, <int, Color>{
        50: Color(0xFFE6EBF3),
        100: Color(0xFFC0CCE0),
        200: Color(0xFF96AACB),
        300: Color(0xFF6B88B6),
        400: Color(0xFF4C6FA7),
        500: Color(0xFF2C5597),
        600: Color(0xFF274E8F),
        700: Color(0xFF214484),
        800: Color(0xFF1B3B7A),
        900: Color(0xFF102A69),
      })),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const MyHomePage(title: 'Demo'),
        '/simulator': (BuildContext context) => const Simulator(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final text = '''
¡Bienvenido a la demo de BucksApp! 

Esta app le demuestrá cómo nuestra herramienta puede lucir integrada a su aplicación bancaria. 

(Los datos utilizados son solo de ejemplo)

''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 64.0, horizontal: 16.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Lorem Ipsum Dolot Est",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Expanded(
                      child: Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(48.0),
                          child: Text(''),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(48.0),
                          child: Text(''),
                        ),
                      ),
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Expanded(
                      child: Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(48.0),
                          child: Text(''),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(48.0),
                          child: Text(''),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            color: const Color(0xE5E5E5FF),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('icons/Logo.svg'),
                          const Text(
                            "DEMO",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(19.0),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
          const Positioned(bottom: 0, right: 32, child: Clip())
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // This is all you need!
        onTap: (int index) {
          if (index == 3) Navigator.of(context).pushNamed('/simulator');
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(UiIcons.housing),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
              icon: Icon(UiIcons.transfer), label: 'Transferir'),
          BottomNavigationBarItem(
              icon: Icon(UiIcons.cashTransaction), label: 'Pagar'),
          BottomNavigationBarItem(
              icon: Icon(UiIcons.financials), label: 'Mis Finanzas'),
        ],
      ),
    );
  }
}

class Simulator extends StatelessWidget {
  const Simulator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SingleChildScrollView(
              child: SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Bucksapp(
                    apiKey: dotenv.get('API_KEY', fallback: ''),
                    uuid: dotenv.get('UUID', fallback: ''),
                    environment: dotenv.get('ENV', fallback: ''),
                  )),
            ),
          );
        }),
      ),
    );
  }
}

class Clip extends StatelessWidget {
  const Clip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'icons/clip.svg',
        ),
        const SizedBox(
          width: 150,
          height: 80,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
            child: Text(
              'Tocá acá para empezar',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
