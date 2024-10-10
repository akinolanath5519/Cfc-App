import 'package:agriproduce/screens/login_page.dart';
import 'package:agriproduce/state_management/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriProduce',
      theme: lightTheme(), // Light theme
      darkTheme: darkTheme(), // Dark theme
      themeMode: ThemeMode.system, // Choose system theme by default
      home: Consumer(
        builder: (context, ref, child) {
          // Load the token when the app starts
          loadToken(ref);
          return LoginPage();
        },
      ),
    );
  }
}

// Light theme configuration
ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple, // Primary color set to deepPurple
    primaryColor: Colors.deepPurple,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.deepPurpleAccent, // Complementary purple accent
    ),
    scaffoldBackgroundColor:
        Colors.grey[100], // Light background to match purple
    appBarTheme: AppBarTheme(
      color: Colors.deepPurple,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ).titleLarge,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
      labelLarge:
          TextStyle(color: Colors.deepPurple), // Set label color to deep purple
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple, // Updated button color
        foregroundColor: Colors.white, // Updated text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Increased corner radius
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepPurpleAccent, // Updated text button color
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color.fromARGB(
          255, 122, 65, 221), // Floating action button color
      foregroundColor: Colors.white, // Icon color
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3), // Very faint border
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
            color: Colors.deepPurple), // Focused border to deep purple
      ),
      labelStyle:
          TextStyle(color: Colors.deepPurple), // Label color to deep purple
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    // Page transition settings
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

// Dark theme configuration
ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple, // Primary color set to deepPurple
    primaryColor: Colors.deepPurple[700],
    colorScheme: ColorScheme.dark().copyWith(
      secondary:
          Colors.deepPurpleAccent, // Use deep purple accent for dark theme
    ),
    scaffoldBackgroundColor:
        Colors.grey[900], // Dark background to match purple
    appBarTheme: AppBarTheme(
      color: Colors.deepPurple[700],
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ).titleLarge,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white70),
      labelLarge: TextStyle(
          color: Colors.deepPurple[200]), // Label color for dark theme
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple[700], // Updated button color
        foregroundColor: Colors.white, // Updated text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Increased corner radius
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors
            .deepPurpleAccent[100], // Updated text button color in dark theme
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple[700], // FAB color in dark theme
      foregroundColor: Colors.white, // Icon color
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3), // Very faint border
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.deepPurple[700]!),
      ),
      labelStyle: TextStyle(
          color: Colors.deepPurple[200]), // Label color for dark theme
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    // Page transition settings
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
