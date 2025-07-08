import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor_app/frontend/functionalities/basic_functionality.dart';
import 'package:photo_editor_app/frontend/language_support/locale_provider.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'frontend/navigation_menu/phone_nav_menu.dart';
import 'frontend/navigation_menu/windows_nav_menu.dart';
import 'frontend/pages/profile/accent_color_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AccentColorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Optimize theme mode
  ThemeMode _themeMode = ThemeMode.light;
  Widget? _homeScreen;
  Color _accentColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadAccentColor();
    _loadThemeMode().then((_) => _startInitialization());
  }

  Future<void> _loadAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorString = prefs.getString('accentColor');

    setState(() {
      if (colorString == null) {
        _accentColor = Colors.blueAccent;
      } else {
        _accentColor = Essentials().colorFromHex(colorString);
      }
    });
  }

  Future<void> _requestPermissions() async {
    final photosStatus = await Permission.photos.request();
    final videosStatus = await Permission.videos.request();
    final storageStatus = await Permission.storage.request();
  }

  Future<void> _startInitialization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    Widget nextScreen;
    if (Platform.isWindows) {
      nextScreen = WindowsMenu(
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
        userId: userId,
      );
    } else {
      nextScreen = AndroidMenu(
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
        userId: userId,
      );
    }

    setState(() {
      _homeScreen = nextScreen;
    });
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await prefs.setBool('isDarkMode', newTheme == ThemeMode.dark);
    setState(() {
      _themeMode = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Lixy',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _accentColor),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _accentColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      locale: provider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: _homeScreen ?? const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
