import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/categories_service.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:ebom/src/services/search_service.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) setPathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConnexionProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(
          create: (context) => AppLayoutNavigationProvider(),
        ),
      ],
      child: const EbomApp(),
    ),
  );
}
