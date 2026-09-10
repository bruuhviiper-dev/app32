import 'package:flutter/material.dart';

/// Uma mensagem (texto + rótulo opcional, ex.: "Bom dia").
class Verse {
  const Verse(this.text, [this.reference = '']);

  final String text;
  final String reference;

  String get id => '$reference::${text.hashCode}';

  /// Texto pronto pra compartilhar — LIMPO (só a cantada), sem propaganda no
  /// meio da mensagem. A divulgação do app fica na imagem (marca d'água) e nas
  /// telas próprias, não grudada na cantada enviada pro crush.
  String get shareText => reference.isEmpty ? text : '$text\n— $reference';
}

/// Categoria de versículos (ex.: Fé, Esperança, Amor...).
class VerseCategory {
  const VerseCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.gradient,
    required this.verses,
    this.premium = false,
  });

  final String id;
  final String name;
  final String emoji;
  final List<Color> gradient;
  final List<Verse> verses;

  /// Categoria exclusiva: só liberada com o pacote premium / assinatura.
  final bool premium;
}
