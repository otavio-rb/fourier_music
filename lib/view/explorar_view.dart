import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/explore_controller.dart';
import 'widgets/song_tile_widget.dart';

class ExplorarView extends StatelessWidget {
  const ExplorarView({super.key});

  static const List<Map<String, dynamic>> _generosCard = [
    {
      'nome': 'Barroco',
      'cor1': Color(0xFF1E3A2F),
      'cor2': Color(0xFF2E5A44),
      'icone': Icons.auto_stories,
    },
    {
      'nome': 'Piano Solo',
      'cor1': Color(0xFF1B2A4A),
      'cor2': Color(0xFF384E77),
      'icone': Icons.piano,
    },
    {
      'nome': 'Romântico',
      'cor1': Color(0xFF4A1525),
      'cor2': Color(0xFF7A203A),
      'icone': Icons.favorite_rounded,
    },
    {
      'nome': 'Orquestral',
      'cor1': Color(0xFF3D2C1D),
      'cor2': Color(0xFF6B4E32),
      'icone': Icons.album_rounded,
    },
    {
      'nome': 'Coral & Ópera',
      'cor1': Color(0xFF5B1E1E),
      'cor2': Color(0xFF8B2E2E),
      'icone': Icons.church_rounded,
    },
    {
      'nome': 'Todos',
      'cor1': Color(0xFF1F2937),
      'cor2': Color(0xFF374151),
      'icone': Icons.music_note_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final exploreCtrl = GetIt.I.get<ExploreController>();

    return ListenableBuilder(
      listenable: exploreCtrl,
      builder: (context, _) {
        final musicasExibidas = exploreCtrl.musicasFiltradasPorCategoria;

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text(
                  'Gêneros & Momentos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _generosCard[index];
                    final nome = item['nome'] as String;
                    final isAtivo = exploreCtrl.categoriaSelecionada == nome;

                    return GestureDetector(
                      onTap: () {
                        if (isAtivo) {
                          exploreCtrl.selecionarCategoria('Todos');
                        } else {
                          exploreCtrl.selecionarCategoria(nome);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [item['cor1'] as Color, item['cor2'] as Color],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: isAtivo
                              ? Border.all(color: Colors.white, width: 2.5)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              item['icone'] as IconData,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 26,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _generosCard.length,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exploreCtrl.categoriaSelecionada == 'Todos'
                          ? 'Paradas & Em Alta'
                          : 'Destaques de ${exploreCtrl.categoriaSelecionada}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (exploreCtrl.categoriaSelecionada != 'Todos')
                      TextButton(
                        onPressed: () {
                          exploreCtrl.selecionarCategoria('Todos');
                        },
                        child: const Text('Limpar filtro'),
                      ),
                  ],
                ),
              ),
            ),

            if (musicasExibidas.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Nenhuma música encontrada nesta categoria.',
                      style: TextStyle(color: Color(0xFFAAAAAA)),
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final musica = musicasExibidas[index];
                    return SongTileWidget(
                      musica: musica,
                      listaContexto: musicasExibidas,
                      numeroFaixa: index + 1,
                    );
                  },
                  childCount: musicasExibidas.length,
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        );
      },
    );
  }
}
