import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Cartão da cantada em estilo "conversa de chat" (print de WhatsApp).
///
/// É a identidade visual do app: a cantada aparece como uma mensagem sendo
/// enviada pro crush. Serve tanto para a tela quanto para exportar como imagem
/// ("print de conversa") via [captureKey].
class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.text,
    this.captureKey,
    this.crushName = 'Crush 💘',
    this.replyEmoji = '😍',
    this.showHeader = true,
    this.showReply = true,
    this.borderRadius = 24,
  });

  final String text;
  final GlobalKey? captureKey;
  final String crushName;
  final String replyEmoji;
  final bool showHeader;
  final bool showReply;
  final double borderRadius;

  static const _wallLight = Color(0xFFE7DCD3); // bege do chat
  static const _bubbleOut = Color(0xFFDCF8C6); // verde msg enviada
  static const _bubbleIn = Colors.white;
  static const _headerColor = Color(0xFF128C7E); // verde WhatsApp

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: captureKey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          color: _wallLight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showHeader) _header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: Column(
                  children: [
                    _outBubble(text),
                    if (showReply) ...[
                      const SizedBox(height: 8),
                      _inBubble(replyEmoji),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Container(
        color: _headerColor,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              child: Text('💘', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(crushName,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Text('online',
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 11)),
              ],
            ),
          ],
        ),
      );

  Widget _outBubble(String t) => Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Container(
            decoration: const BoxDecoration(
              color: _bubbleOut,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(2),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t,
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF111B21),
                        fontSize: 15,
                        height: 1.32)),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('agora',
                        style: GoogleFonts.poppins(
                            color: Colors.black45, fontSize: 10)),
                    const SizedBox(width: 3),
                    const Icon(Icons.done_all_rounded,
                        size: 15, color: Color(0xFF34B7F1)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _inBubble(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: const BoxDecoration(
            color: _bubbleIn,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(14),
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Text(t, style: const TextStyle(fontSize: 20)),
        ),
      );
}

/// Captura o [ChatCard] de [key] como PNG em alta resolução.
Future<Uint8List?> captureChatImage(GlobalKey key) async {
  final ctx = key.currentContext;
  if (ctx == null) return null;
  final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return null;
  final img = await boundary.toImage(pixelRatio: 3.0);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data?.buffer.asUint8List();
}

/// Exporta o print de conversa e abre o compartilhamento.
Future<void> shareChatImage(GlobalKey key, {String? text}) async {
  final bytes = await captureChatImage(key);
  if (bytes == null) return;
  final dir = await getTemporaryDirectory();
  final file = File(
      '${dir.path}/cantada_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(bytes);
  await Share.shareXFiles([XFile(file.path)], text: text);
}
