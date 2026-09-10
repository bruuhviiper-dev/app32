import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/app_theme.dart';
import '../data/models.dart';
import 'share_helper.dart';

/// Cartão da mensagem renderizado como IMAGEM (gradiente + texto), pronto para
/// compartilhar/salvar. Quando um [captureKey] é passado, o conteúdo é
/// envolvido num RepaintBoundary para exportar a imagem em alta resolução.
class VerseImageCard extends StatelessWidget {
  const VerseImageCard({
    super.key,
    required this.verse,
    required this.gradient,
    this.captureKey,
    this.borderRadius = 24,
    this.fontSize = 22,
  });

  final Verse verse;
  final List<Color> gradient;
  final GlobalKey? captureKey;
  final double borderRadius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: captureKey,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.gradient(gradient),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -14,
              bottom: -20,
              child: Icon(Icons.local_fire_department_rounded,
                  size: 150, color: Colors.white.withValues(alpha: 0.10)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(26, 34, 26, 44),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      verse.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        color: Colors.white,
                        fontSize: fontSize,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        shadows: const [
                          Shadow(
                              color: Colors.black38,
                              blurRadius: 10,
                              offset: Offset(0, 2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🔥 Cantadas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      )),
                  Text('Baixe grátis na Play Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Captura o RepaintBoundary de [key] como PNG em alta.
Future<Uint8List?> captureVerseImage(GlobalKey key) async {
  final ctx = key.currentContext;
  if (ctx == null) return null;
  final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return null;
  final img = await boundary.toImage(pixelRatio: 3.0);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data?.buffer.asUint8List();
}

/// Exporta e compartilha a imagem do cartão.
Future<void> shareVerseImage(GlobalKey key) async {
  final bytes = await captureVerseImage(key);
  if (bytes == null) return;
  final dir = await getTemporaryDirectory();
  final file = File(
      '${dir.path}/mensagem_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(bytes);
  await Share.shareXFiles([XFile(file.path)]);
}

/// Gradientes PAIXÃO/FOGO para o card compartilhável.
const _fireGradients = <List<Color>>[
  [Color(0xFFFF416C), Color(0xFFFF4B2B)],
  [Color(0xFFC9184A), Color(0xFFFF2E63)],
  [Color(0xFFF12711), Color(0xFFF5AF19)],
  [Color(0xFF6A0136), Color(0xFFFF7A00)],
  [Color(0xFFEE0979), Color(0xFFFF6A00)],
  [Color(0xFF8E0E00), Color(0xFFFF4B2B)],
  [Color(0xFFB91D73), Color(0xFFF953C6)],
  [Color(0xFF200122), Color(0xFF6F0000)],
];

List<Color> fireGradientFor(String seed) =>
    _fireGradients[seed.hashCode.abs() % _fireGradients.length];

/// Renderiza a [verse] num card de FOGO fora da tela e compartilha como IMAGEM.
/// Usado no botão "Compartilhar" dos cartões de cantada (sem texto promocional).
Future<void> renderAndShareVerse(BuildContext context, Verse verse) async {
  final key = GlobalKey();
  final overlay = Overlay.of(context, rootOverlay: true);
  final entry = OverlayEntry(
    builder: (_) => Positioned(
      left: -2000,
      top: 0,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 380,
          height: 475,
          child: VerseImageCard(
            verse: verse,
            gradient: fireGradientFor(verse.text),
            captureKey: key,
            fontSize: 24,
          ),
        ),
      ),
    ),
  );
  overlay.insert(entry);
  // Espera layout + pintura antes de capturar.
  await Future.delayed(const Duration(milliseconds: 80));
  await WidgetsBinding.instance.endOfFrame;
  await shareVerseImage(key);
  entry.remove();
}

/// "Mandar no Zap": envia a IMAGEM do cartão (com [text] de legenda) direto pro
/// WhatsApp. Se o WhatsApp não estiver instalado, cai no compartilhamento padrão
/// (que também envia a imagem).
Future<void> sendVerseImageToWhatsApp(GlobalKey key, String text) async {
  final bytes = await captureVerseImage(key);
  if (bytes == null) return;
  final dir = await getTemporaryDirectory();
  final file = File(
      '${dir.path}/cantada_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(bytes);
  final ok = await ShareHelper.sendImageToWhatsApp(file.path, text);
  if (!ok) {
    await Share.shareXFiles([XFile(file.path)], text: text);
  }
}

/// Salva a imagem do cartão na galeria (HD). Retorna true se salvou.
Future<bool> saveVerseImage(GlobalKey key) async {
  final bytes = await captureVerseImage(key);
  if (bytes == null) return false;
  try {
    await Gal.putImageBytes(bytes, album: 'Cantadas');
    return true;
  } catch (_) {
    return false;
  }
}
