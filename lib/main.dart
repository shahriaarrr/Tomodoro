import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tomodoro/models/tasky.dart';
import 'package:tomodoro/pages/home.dart';
import 'package:tomodoro/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskyAdapter());
  Hive.registerAdapter(TaskyPriorityAdapter());

  await Tasky.openBox();

  runApp(ProviderScope(child: const MyApp()));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      themeProvider.select(
        (theme) => ref.read(themeProvider.notifier).themeMode,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),

      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey[100],
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        canvasColor: Colors.grey[850],
      ),

      themeMode: themeMode,
    );
  }
}
