import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tour_guide_application/Controllers/authentication/auth_controller.dart';
import 'package:tour_guide_application/Controllers/authentication/auth_gate.dart';
import 'package:tour_guide_application/Utilis/Theme/chatbot_theme.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/Controllers/chatbot/chatbot_controller.dart';
import 'package:tour_guide_application/Utilis/routes.dart';
import 'package:tour_guide_application/core/config/app_config.dart';
import 'package:tour_guide_application/l10n/app_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    AppConfig.validate();
    log("Initializing Supabase...");
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      debug: true,
    );
    log("✅ Supabase Initialized Successfully");
    runApp(const MyApp());
  } catch (e) {
    log("❌ Supabase initialization error: $e");
    runApp(const ErrorApp());
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Failed to initialize the app. Please try again later.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationController()),
        ChangeNotifierProvider(create: (_) => CalendarController()),
        ChangeNotifierProvider(create: (_) => CountryController()),
        ChangeNotifierProvider(create: (_) => AlbumController()),
        ChangeNotifierProvider(create: (_) => ChatbotController()),
      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travel Explorer AI',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: AppColors.lightBackground,
          fontFamily: 'Poppins',
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: AppColors.darkBackground,
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return supportedLocales.first;
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: const AuthGate(),
        routes: Routes.getRoutes(),
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
