import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper de compartilhamento/cópia (texto) + envio direto pro WhatsApp.
class ShareHelper {
  ShareHelper._();

  static const _channel = MethodChannel('cantadas/share');

  /// Envia a IMAGEM [path] direto pro WhatsApp (com legenda [text]).
  /// Retorna true se o WhatsApp abriu; false se não está instalado.
  static Future<bool> sendImageToWhatsApp(String path, String text) async {
    try {
      final ok = await _channel.invokeMethod<bool>(
          'toWhatsAppImage', {'path': path, 'text': text});
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> share(String text) async {
    await Share.share(text);
  }

  static Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// "Manda pro crush": abre o WhatsApp já com a cantada pronta pra enviar.
  /// Se o WhatsApp não abrir, cai no compartilhamento padrão do sistema.
  static Future<void> sendToWhatsApp(String text) async {
    final encoded = Uri.encodeComponent(text);
    final wa = Uri.parse('whatsapp://send?text=$encoded');
    try {
      if (await canLaunchUrl(wa)) {
        await launchUrl(wa, mode: LaunchMode.externalApplication);
        return;
      }
      final web = Uri.parse('https://wa.me/?text=$encoded');
      if (await canLaunchUrl(web)) {
        await launchUrl(web, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}
    await Share.share(text);
  }
}
