import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/verses.dart';
import '../services/app_state.dart';
import '../widgets/banner_ad.dart';
import '../widgets/share_helper.dart';
import '../widgets/verse_image.dart';
import 'create_screen.dart';

/// Roleta de Cantadas: sorteia uma cantada (opcionalmente de uma categoria) e
/// mostra sobre um fundo de FOGO (a identidade do app). Botões pra mandar no
/// Zap, copiar, compartilhar a imagem e favoritar.
class RoletaScreen extends StatefulWidget {
  const RoletaScreen({super.key});

  @override
  State<RoletaScreen> createState() => _RoletaScreenState();
}

class _RoletaScreenState extends State<RoletaScreen> {
  final _rng = Random();
  final _imgKey = GlobalKey();
  String? _catId; // null = todas
  late Verse _current;
  late List<Color> _gradient;

  // Gradientes PAIXÃO/FOGO usados no card compartilhável.
  static const _fireGradients = <List<Color>>[
    [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    [Color(0xFFC9184A), Color(0xFFFF2E63)],
    [Color(0xFFF12711), Color(0xFFF5AF19)],
    [Color(0xFF6A0136), Color(0xFFFF7A00)],
    [Color(0xFFEE0979), Color(0xFFFF6A00)],
    [Color(0xFF8E0E00), Color(0xFFFF4B2B)],
    [Color(0xFFB91D73), Color(0xFFF953C6)],
    [Color(0xFF200122), Color(0xFF6F0000)],
  ];

  @override
  void initState() {
    super.initState();
    _gradient = _fireGradients.first;
    _current = _pool().isEmpty ? const Verse('...') : _random();
  }

  List<Verse> _pool() {
    if (_catId == null) return VerseData.all;
    return VerseData.categoryById(_catId!).verses;
  }

  Verse _random() {
    final pool = _pool();
    _gradient = _fireGradients[_rng.nextInt(_fireGradients.length)];
    return pool[_rng.nextInt(pool.length)];
  }

  void _shuffle() => setState(() => _current = _random());

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fav = state.isFavorite(_current.id);
    return Scaffold(
      bottomNavigationBar: const BannerPlaceholder(),
      appBar: AppBar(title: const Text('🎲 Roleta de Cantadas')),
      body: Column(
        children: [
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
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Column(
                children: [
                  // Card de FOGO com a cantada (compartilhável como imagem)
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: _gradient.last.withValues(alpha: 0.40),
                              blurRadius: 22,
                              offset: const Offset(0, 10)),
                        ],
                      ),
                      child: VerseImageCard(
                        verse: _current,
                        gradient: _gradient,
                        captureKey: _imgKey,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          sendVerseImageToWhatsApp(_imgKey, _current.text),
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
                        icon: Icons.edit_rounded,
                        label: 'Editar',
                        onTap: () => Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (_) =>
                                    CreateScreen(initialText: _current.text))),
                      ),
                      _action(
                        icon: Icons.ios_share_rounded,
                        label: 'Compartilhar',
                        onTap: () => shareVerseImage(_imgKey),
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
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), duration: const Duration(seconds: 2)));
  }
}
