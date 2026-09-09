import 'package:flutter/material.dart';

/// Tema do app — rosé/coral (bonito, delicado, pôr do sol).
class AppTheme {
  AppTheme._();

  static const brand = Color(0xFFFF2E63); // vermelho-rosa (paixão)
  static const brandDark = Color(0xFFC9184A);
  static const gold = Color(0xFFFFB3C6);

  /// Gradiente da "frase do dia" e da marca.
  static const hero = [Color(0xFFFF416C), Color(0xFFFF4B2B)];

  static LinearGradient gradient(List<Color> colors) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      );

  static ThemeData light([Color accent = brand]) {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.light),
      scaffoldBackgroundColor: const Color(0xFFFFF5F8),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }

  static ThemeData dark([Color accent = brand]) {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.dark),
      scaffoldBackgroundColor: const Color(0xFF1A0E14),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
