import 'package:flutter/material.dart';

/// Fundos-imagem para o nicho de AMIZADE. Começa pelos TEMÁTICOS novos (hora
/// dourada, amigos ao pôr do sol, luzes, corações, balões, azul+ouro da capa —
/// desenhados p/ o app), depois os estéticos mais quentes e por fim os
/// genéricos. Assets leves, offline.
class ImageBackgrounds {
  ImageBackgrounds._();

  /// Cenas de amizade desenhadas para o app (as mais aderentes ao tema).
  static const List<String> _amizade = [
    'assets/backgrounds/bg_amz01_horadourada.jpg',
    'assets/backgrounds/bg_amz02_amigos.jpg',
    'assets/backgrounds/bg_amz03_luzes.jpg',
    'assets/backgrounds/bg_amz04_coracoes.jpg',
    'assets/backgrounds/bg_amz05_bokeh.jpg',
    'assets/backgrounds/bg_amz06_azulouro.jpg',
    'assets/backgrounds/bg_amz07_confete.jpg',
    'assets/backgrounds/bg_amz08_pordosol.jpg',
    'assets/backgrounds/bg_amz09_baloes.jpg',
    'assets/backgrounds/bg_amz10_aconchego.jpg',
    'assets/backgrounds/bg_amz11_ouro.jpg',
    'assets/backgrounds/bg_amz12_noite.jpg',
  ];

  /// Estéticos: os quentes/afetivos primeiro (pôr do sol, corações, bokeh).
  static const List<String> _estetico = [
    'assets/backgrounds/bg_pordosol.png',
    'assets/backgrounds/bg_coracoes.png',
    'assets/backgrounds/bg_bokeh.png',
    'assets/backgrounds/bg_ceu.png',
    'assets/backgrounds/bg_pastel.png',
    'assets/backgrounds/bg_flores.png',
  ];

  static List<String> get all => [
        ..._amizade,
        ..._estetico,
        for (var i = 1; i <= 96; i++)
          'assets/backgrounds/bg${i.toString().padLeft(2, '0')}.jpg',
      ];
}

/// Filtros de cor aplicados por cima do fundo (tinta translúcida). Dão a
/// sensação de "mais opções" sem precisar de mil imagens.
class CardFilters {
  CardFilters._();

  static const List<String> names = [
    'Original',
    'Quente',
    'Frio',
    'Rosé',
    'Vintage',
    'Escuro',
    'Claro',
  ];

  /// Cor da tinta do filtro [i] (0 = Original / sem filtro).
  static Color? color(int i) => switch (i) {
        1 => const Color(0x33FF7A18), // quente
        2 => const Color(0x332A6FFF), // frio
        3 => const Color(0x33FF3D8B), // rosé
        4 => const Color(0x40C9A24B), // vintage
        5 => const Color(0x59000000), // escuro
        6 => const Color(0x26FFFFFF), // claro
        _ => null,
      };
}
