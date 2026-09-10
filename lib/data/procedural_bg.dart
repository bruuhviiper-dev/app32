import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Fundo PROCEDURAL: a arte é desenhada no aparelho (CustomPainter) a partir de
/// um `seed`. Combinando paletas × estilos de ornamento × posições, o espaço de
/// variação é imenso ("infinito") sem guardar nenhuma imagem no APK.
///
/// Mesmo seed => mesma arte (estável por frase). Cada frase recebe um seed
/// diferente, então a galeria nunca parece repetitiva.
class ProceduralBg {
  ProceduralBg._();

  /// Paletas base (gradiente) PAIXÃO/FOGO — vermelho, laranja, magenta e
  /// crimson quentes. Alto contraste pra texto claro.
  static const List<List<Color>> palettes = [
    [Color(0xFF2B0010), Color(0xFFFF4B2B)], // crimson -> laranja
    [Color(0xFF6A0136), Color(0xFFFF2E63)], // vinho -> rosa-choque
    [Color(0xFF3A001F), Color(0xFFF12711)], // escuro -> vermelho
    [Color(0xFF1A0022), Color(0xFFC9184A)], // roxo escuro -> carmim
    [Color(0xFF7B0828), Color(0xFFFF7A00)], // bordô -> laranja
    [Color(0xFF2C0008), Color(0xFFF5AF19)], // brasa -> âmbar
    [Color(0xFF4A002A), Color(0xFFFF3CAC)], // vinho -> magenta
    [Color(0xFF240014), Color(0xFFEB3349)], // escuro -> coral quente
    [Color(0xFF8E0E00), Color(0xFFFF4B2B)], // fogo profundo
    [Color(0xFFC9184A), Color(0xFFFF7A00)], // carmim -> laranja
    [Color(0xFFB91D73), Color(0xFFF953C6)], // magenta intenso
    [Color(0xFFEE0979), Color(0xFFFF6A00)], // rosa -> laranja
    [Color(0xFF200122), Color(0xFF6F0000)], // brasa escura
    [Color(0xFF44107A), Color(0xFFFF1361)], // roxo -> rosa-fogo
    [Color(0xFFCB356B), Color(0xFFBD3F32)], // rosa -> tijolo
    [Color(0xFFF12711), Color(0xFFF5AF19)], // laranja quente
  ];

  static const int _styles = 7;

  /// Total de combinações "principais" (paleta × estilo × direção do gradiente).
  static int get variety => palettes.length * _styles * 4;

  static int seedFor(String text) => text.hashCode & 0x7fffffff;
}

/// PRNG determinístico (LCG) — leve e estável.
class _Rnd {
  _Rnd(int seed) : _s = (seed == 0 ? 1 : seed) & 0xffffffff;
  int _s;
  double next() {
    _s = (_s * 1664525 + 1013904223) & 0xffffffff;
    return _s / 0xffffffff;
  }

  double range(double a, double b) => a + (b - a) * next();
  int intg(int n) => (next() * n).floor() % n;
}

class ProceduralPainter extends CustomPainter {
  ProceduralPainter(this.seed);
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final r = _Rnd(seed);
    final pal = ProceduralBg.palettes[seed % ProceduralBg.palettes.length];
    final rect = Offset.zero & size;

    // --- Base: gradiente com direção variável ---
    final dir = (seed ~/ ProceduralBg.palettes.length) % 4;
    final begins = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
    ];
    final ends = [
      Alignment.bottomRight,
      Alignment.bottomCenter,
      Alignment.bottomLeft,
      Alignment.centerRight,
    ];
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
                colors: pal, begin: begins[dir], end: ends[dir])
            .createShader(rect),
    );

    final style =
        (seed ~/ (ProceduralBg.palettes.length * 4)) % ProceduralBg._styles;
    final w = size.width, h = size.height;
    final tint = _mix(pal[0], pal[1], 0.5);

    switch (style) {
      case 0:
        _bokeh(canvas, r, w, h);
        break;
      case 1:
        _dots(canvas, r, w, h);
        break;
      case 2:
        _waves(canvas, r, w, h, tint);
        break;
      case 3:
        _hearts(canvas, r, w, h);
        break;
      case 4:
        _sparkles(canvas, r, w, h);
        break;
      case 5:
        _rings(canvas, r, w, h);
        break;
      case 6:
        _confetti(canvas, r, w, h);
        break;
    }

    // --- Vinheta suave (dá profundidade e contraste pro texto) ---
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.28)],
          stops: const [0.62, 1.0],
        ).createShader(rect),
    );
  }

  Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t)!;

  void _bokeh(Canvas c, _Rnd r, double w, double h) {
    final n = 10 + r.intg(10);
    for (var i = 0; i < n; i++) {
      final radius = r.range(w * 0.05, w * 0.22);
      c.drawCircle(
        Offset(r.range(0, w), r.range(0, h)),
        radius,
        Paint()..color = Colors.white.withValues(alpha: r.range(0.03, 0.12)),
      );
    }
  }

  void _dots(Canvas c, _Rnd r, double w, double h) {
    final step = w / (5 + r.intg(4));
    final rad = step * 0.10;
    for (var y = step * 0.5; y < h; y += step) {
      for (var x = step * 0.5; x < w; x += step) {
        c.drawCircle(
          Offset(x + r.range(-4, 4), y + r.range(-4, 4)),
          rad,
          Paint()..color = Colors.white.withValues(alpha: 0.10),
        );
      }
    }
  }

  void _waves(Canvas c, _Rnd r, double w, double h, Color tint) {
    final bands = 3 + r.intg(3);
    for (var b = 0; b < bands; b++) {
      final path = Path();
      final baseY = h * (b + 1) / (bands + 1) + r.range(-h * 0.05, h * 0.05);
      final amp = r.range(h * 0.02, h * 0.06);
      final len = r.range(w * 0.35, w * 0.7);
      path.moveTo(0, baseY);
      for (var x = 0.0; x <= w; x += w / 24) {
        path.lineTo(x, baseY + math.sin(x / len * math.pi * 2) * amp);
      }
      path.lineTo(w, h);
      path.lineTo(0, h);
      path.close();
      c.drawPath(
        path,
        Paint()..color = Colors.white.withValues(alpha: 0.06),
      );
    }
  }

  /// Brasas subindo (pontinhos de luz quente) — clima de fogo.
  void _hearts(Canvas c, _Rnd r, double w, double h) {
    final n = 26 + r.intg(24);
    for (var i = 0; i < n; i++) {
      final s = r.range(1.5, 4.5);
      final o = Offset(r.range(0, w), r.range(h * 0.25, h));
      c.drawCircle(
        o,
        s,
        Paint()
          ..color = Color.lerp(const Color(0xFFFFC148), const Color(0xFFFF5A1F),
                  r.range(0, 1))!
              .withValues(alpha: r.range(0.25, 0.7)),
      );
    }
  }

  void _sparkles(Canvas c, _Rnd r, double w, double h) {
    final n = 12 + r.intg(12);
    for (var i = 0; i < n; i++) {
      _star(c, Offset(r.range(0, w), r.range(0, h)), r.range(4, 14),
          Colors.white.withValues(alpha: r.range(0.15, 0.5)));
    }
  }

  void _star(Canvas c, Offset o, double s, Color color) {
    final p = Path();
    p.moveTo(o.dx, o.dy - s);
    p.quadraticBezierTo(o.dx, o.dy, o.dx + s, o.dy);
    p.quadraticBezierTo(o.dx, o.dy, o.dx, o.dy + s);
    p.quadraticBezierTo(o.dx, o.dy, o.dx - s, o.dy);
    p.quadraticBezierTo(o.dx, o.dy, o.dx, o.dy - s);
    c.drawPath(p, Paint()..color = color);
  }

  void _rings(Canvas c, _Rnd r, double w, double h) {
    final cx = r.range(w * 0.2, w * 0.8), cy = r.range(h * 0.2, h * 0.8);
    final n = 4 + r.intg(4);
    for (var i = 0; i < n; i++) {
      c.drawCircle(
        Offset(cx, cy),
        w * 0.12 * (i + 1),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: 0.10),
      );
    }
  }

  /// Línguas de fogo subindo do rodapé (camadas translúcidas laranja/amarelo).
  void _confetti(Canvas c, _Rnd r, double w, double h) {
    final n = 4 + r.intg(3);
    for (var i = 0; i < n; i++) {
      final cx = r.range(w * 0.1, w * 0.9);
      final fw = r.range(w * 0.12, w * 0.22);
      final fh = r.range(h * 0.18, h * 0.34);
      _flame(c, cx, h + 8, fw, fh,
          const Color(0xFFFF7A1F).withValues(alpha: 0.16));
      _flame(c, cx, h + 8, fw * 0.6, fh * 0.7,
          const Color(0xFFFFD34E).withValues(alpha: 0.20));
    }
  }

  void _flame(Canvas c, double cx, double baseY, double fw, double fh,
      Color color) {
    final p = Path()
      ..moveTo(cx - fw / 2, baseY)
      ..cubicTo(cx - fw * 0.35, baseY - fh * 0.5, cx - fw * 0.12,
          baseY - fh * 0.72, cx, baseY - fh)
      ..cubicTo(cx + fw * 0.12, baseY - fh * 0.72, cx + fw * 0.35,
          baseY - fh * 0.5, cx + fw / 2, baseY)
      ..close();
    c.drawPath(p, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant ProceduralPainter old) => old.seed != seed;
}
