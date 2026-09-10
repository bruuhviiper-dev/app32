import 'package:flutter/material.dart';

/// Fundo de imagem para o cartão de story. Alguns são grátis; os marcados como
/// [premium] fazem parte do valor da loja (temas/pacote/assinatura).
class StoryBg {
  const StoryBg(this.colors, {this.premium = false, this.asset});
  final List<Color> colors;
  final bool premium;

  /// Caminho de uma imagem offline (assets/backgrounds/...). Quando presente,
  /// o fundo usa a foto em vez do gradiente.
  final String? asset;
  bool get isImage => asset != null;

  static const List<StoryBg> all = [
    // ----- imagens FOGO/PAIXÃO offline (grátis) -----
    StoryBg([Color(0xFF2B0010), Color(0xFFFF4B2B)],
        asset: 'assets/backgrounds/bg_fogo01.jpg'),
    StoryBg([Color(0xFF6A0136), Color(0xFFFF2E63)],
        asset: 'assets/backgrounds/bg_fogo02.jpg'),
    StoryBg([Color(0xFF3A001F), Color(0xFFF12711)],
        asset: 'assets/backgrounds/bg_fogo03.jpg'),
    StoryBg([Color(0xFF1A0022), Color(0xFFC9184A)],
        asset: 'assets/backgrounds/bg_fogo04.jpg'),
    StoryBg([Color(0xFF7B0828), Color(0xFFFF7A00)],
        asset: 'assets/backgrounds/bg_fogo05.jpg'),
    // ----- gradientes fogo (grátis) -----
    StoryBg([Color(0xFFFF416C), Color(0xFFFF4B2B)]),
    StoryBg([Color(0xFFF12711), Color(0xFFF5AF19)]),
    StoryBg([Color(0xFFC9184A), Color(0xFFFF2E63)]),
    StoryBg([Color(0xFFEE0979), Color(0xFFFF6A00)]),
    StoryBg([Color(0xFF200122), Color(0xFF6F0000)]),
    // ----- imagens fogo premium -----
    StoryBg([Color(0xFF2C0008), Color(0xFFF5AF19)],
        asset: 'assets/backgrounds/bg_fogo06.jpg', premium: true),
    StoryBg([Color(0xFF4A002A), Color(0xFFFF3CAC)],
        asset: 'assets/backgrounds/bg_fogo07.jpg', premium: true),
    StoryBg([Color(0xFF240014), Color(0xFFEB3349)],
        asset: 'assets/backgrounds/bg_fogo08.jpg', premium: true),
    StoryBg([Color(0xFF2B0010), Color(0xFFFF4B2B)],
        asset: 'assets/backgrounds/bg_fogo09.jpg', premium: true),
    StoryBg([Color(0xFF6A0136), Color(0xFFFF2E63)],
        asset: 'assets/backgrounds/bg_fogo10.jpg', premium: true),
    StoryBg([Color(0xFF3A001F), Color(0xFFF12711)],
        asset: 'assets/backgrounds/bg_fogo11.jpg', premium: true),
    StoryBg([Color(0xFF1A0022), Color(0xFFC9184A)],
        asset: 'assets/backgrounds/bg_fogo12.jpg', premium: true),
    StoryBg([Color(0xFF7B0828), Color(0xFFFF7A00)],
        asset: 'assets/backgrounds/bg_fogo13.jpg', premium: true),
    StoryBg([Color(0xFF2C0008), Color(0xFFF5AF19)],
        asset: 'assets/backgrounds/bg_fogo14.jpg', premium: true),
    // ----- gradientes fogo premium -----
    StoryBg([Color(0xFF8E0E00), Color(0xFFFF4B2B)], premium: true),
    StoryBg([Color(0xFFCB356B), Color(0xFFBD3F32)], premium: true),
    StoryBg([Color(0xFFB91D73), Color(0xFFF953C6)], premium: true),
    StoryBg([Color(0xFF6A0136), Color(0xFFFF7A00)], premium: true),
    StoryBg([Color(0xFF44107A), Color(0xFFFF1361)], premium: true),
  ];
}
