import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tomodoro/models/tasky.dart';
import 'package:tomodoro/pages/home.dart';
import 'package:tomodoro/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(TaskyAdapter());
  Hive.registerAdapter(TaskyPriorityAdapter());

  // Open local storage box
  await Tasky.openBox();

  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Run the app with Riverpod provider scope
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current theme mode from provider
    final themeMode = ref.watch(
      themeProvider.select(
        (theme) => ref.read(themeProvider.notifier).themeMode,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),

      // =======================
      //        Light Theme
      // =======================
      theme: ThemeData(
        brightness: Brightness.light,

        // Main color: warm orange
        primaryColor: const Color(0xFFD99E48),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFD99E48),
          secondary: const Color(0xFF3D8B7D),
        ),

        // Main screen background color
        scaffoldBackgroundColor: const Color(0xFFFCF3E3),

        // Cards and containers
        cardColor: const Color(0xFFFFF8E7),

        // AppBar style
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,

          // Icons color
          iconTheme: IconThemeData(color: Color(0xFF3D8B7D)),

          // Title text style
          titleTextStyle: TextStyle(
            color: Color(0xFF3D8B7D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        // Floating action button style
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD99E48),
          foregroundColor: Colors.white,
        ),

        // Bottom navigation bar style
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFFF8E7),
          selectedItemColor: Color(0xFFD99E48),
          unselectedItemColor: Color(0xFF3D8B7D),
        ),

        // Default text styles
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),

      // =======================
      //        Dark Theme
      // =======================
      darkTheme: ThemeData(
        brightness: Brightness.dark,

        // Main color: warm orange
        primaryColor: const Color(0xFFD99E48),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFD99E48),
          secondary: const Color(0xFF3D8B7D),
        ),

        // Main screen background color (dark teal)
        scaffoldBackgroundColor: const Color(0xFF0E1E20),

        // Cards and containers
        cardColor: const Color(0xFF1C313A),

        // Drawer and other surfaces
        canvasColor: const Color(0xFF142B2F),

        // AppBar style
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,

          // Icons color
          iconTheme: IconThemeData(color: Color(0xFFD99E48)),

          // Title text style
          titleTextStyle: TextStyle(
            color: Color(0xFFD99E48),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        // Floating action button style
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD99E48),
          foregroundColor: Colors.black87,
        ),

        // Bottom navigation bar style
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1C313A),
          selectedItemColor: Color(0xFFD99E48),
          unselectedItemColor: Color(0xFF3D8B7D),
        ),

        // Default text styles
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),

      // Dynamic theme switching
      themeMode: themeMode,
    );
  }
}
