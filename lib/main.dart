import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'language_popup.dart';
import 'settings.dart';
import 'package:food/widgets/dark_mode_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => DarkModeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', '');

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;

    // Wait until DarkModeProvider is available in the widget tree
    await Future.delayed(Duration.zero, () {
      context.read<DarkModeProvider>().setDarkMode(isDarkMode);
    });

    FlutterNativeSplash.remove();
  }

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (context, darkModeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: darkModeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          locale: _locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('es', ''),
            Locale('bn', ''),
            Locale('ar', 'AE'),
          ],
          initialRoute: '/home',
          routes: {
            '/home': (context) => HomePage(changeLanguage: changeLanguage),
            '/language': (context) => LanguagePopup(changeLanguage: changeLanguage),
            '/settings': (context) => SettingsPage(
            ),
          },
        );
      },
    );
  }
}
