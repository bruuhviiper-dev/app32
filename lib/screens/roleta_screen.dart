import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/verses.dart';
import '../services/app_state.dart';
import '../widgets/chat_card.dart';
import '../widgets/share_helper.dart';

/// Roleta de Cantadas: sorteia uma cantada (opcionalmente de uma categoria) e
/// mostra em estilo "print de conversa". Botões pra mandar no Zap, copiar,
/// compartilhar o print e favoritar. É o coração divertido do app.
class RoletaScreen extends StatefulWidget {
  const RoletaScreen({super.key});

  @override
  State<RoletaScreen> createState() => _RoletaScreenState();
}

class _RoletaScreenState extends State<RoletaScreen> {
  final _rng = Random();
  final _printKey = GlobalKey();
  String? _catId; // null = todas
  late Verse _current;

  @override
  void initState() {
    super.initState();
    _current = _pool().isEmpty ? const Verse('...') : _random();
  }

  List<Verse> _pool() {
    if (_catId == null) return VerseData.all;
    return VerseData.categoryById(_catId!).verses;
  }

  Verse _random() {
    final pool = _pool();
    return pool[_rng.nextInt(pool.length)];
  }

  void _shuffle() {
    setState(() => _current = _random());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fav = state.isFavorite(_current.id);
    return Scaffold(
      appBar: AppBar(title: const Text('🎲 Roleta de Cantadas')),
      body: Column(
        children: [
          // Filtro por categoria (todas + cada uma)
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
              children: [
                _chip('Todas', null),
                for (final c in VerseData.categories)
                  _chip('${c.emoji} ${c.name}', c.id),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              child: Column(
                children: [
                  ChatCard(text: _current.text, captureKey: _printKey),
                  const SizedBox(height: 20),
                  // Botão grande de sortear
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _shuffle,
                      icon: const Icon(Icons.casino_rounded, size: 22),
                      label: Text('Me dá uma cantada!',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Mandar no Zap (destaque verde)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          ShareHelper.sendToWhatsApp(_current.text),
                      icon: const Icon(Icons.send_rounded, size: 20),
                      label: Text('Mandar no Zap',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _action(
                        icon: Icons.copy_rounded,
                        label: 'Copiar',
                        onTap: () async {
                          await ShareHelper.copy(_current.text);
                          _toast('Cantada copiada! Cola no chat 😏');
                        },
                      ),
                      _action(
                        icon: Icons.ios_share_rounded,
                        label: 'Print',
                        onTap: () => shareChatImage(_printKey,
                            text: '${_current.text}\n\n💘 Cantadas'),
                      ),
                      _action(
                        icon: fav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        label: 'Favoritar',
                        color: fav ? Colors.red : null,
                        onTap: () =>
                            context.read<AppState>().toggleFavorite(_current),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String? id) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: _catId == id,
          onSelected: (_) => setState(() {
            _catId = id;
            _current = _random();
          }),
        ),
      );

  Widget _action({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) =>
      TextButton(
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(m), duration: const Duration(seconds: 2)));
  }
}
