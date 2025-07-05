import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/gateway_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/logs_screen.dart';
import 'models/gateway_config.dart';
import 'services/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentLanguage = 'en';

  void setLocale(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final storage = StorageService();
    final language = await storage.getLanguage();
    setState(() {
      _currentLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GatewayProvider()),
      ],
      child: MaterialApp(
        title: 'GSM-SIP Gateway',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(_currentLanguage),
        supportedLocales: const [
          Locale('en'), // English
          Locale('ru'), // Russian
          Locale('es'), // Spanish
          Locale('fr'), // French
          Locale('de'), // German
          Locale('zh'), // Chinese
          Locale('ja'), // Japanese
          Locale('ko'), // Korean
          Locale('ar'), // Arabic
          Locale('pt'), // Portuguese
          Locale('it'), // Italian
          Locale('th'), // Thai
          Locale('tg'), // Tajik
          Locale('az'), // Azerbaijani
          Locale('km'), // Khmer
          Locale('lo'), // Lao
          Locale('my'), // Myanmar
          Locale('ms'), // Malay
          Locale('sw'), // Swahili (Kenyan/Tanzanian)
          Locale('zu'), // Zulu (South African)
          Locale('af'), // Afrikaans (South African)
          Locale('yo'), // Yoruba (Nigerian)
          Locale('ig'), // Igbo (Nigerian)
          Locale('ha'), // Hausa (Nigerian/West African)
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2A2A2A),
            elevation: 0,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AppWrapper(),
          '/settings': (context) => SettingsScreen(onLocaleChanged: setLocale),
          '/logs': (context) => const LogsScreen(),
        },
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final provider = Provider.of<GatewayProvider>(context, listen: false);
    
    // Wait for provider to initialize
    while (!provider.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Check if we have saved credentials and auto-login is enabled
    final config = provider.config;
    if (config != null && config.sipUsername.isNotEmpty) {
      setState(() {
        _isAuthenticated = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  void _onAuthenticated(GatewayConfig config) {
    setState(() {
      _isAuthenticated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.router,
                size: 80,
                color: Colors.blue[400],
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)?.appTitle ?? 'GSM-SIP Gateway',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        ),
      );
    }

    if (_isAuthenticated) {
      return const DashboardScreen();
    } else {
      return AuthScreen(onAuthenticated: _onAuthenticated);
    }
  }
}
