import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tikdone_app/binding.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/core/routes/pages.dart';
import 'package:tikdone_app/core/routes/routes.dart';

import 'core/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setUpLocator();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ToDo Infinity',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
    
     
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'), // Farsi, IRAN
      ],
      locale: const Locale('fa', 'IR'),
      initialBinding: AuthBinding(),
      getPages: routes,
      initialRoute: PageName.splash,
    );
  }
}
