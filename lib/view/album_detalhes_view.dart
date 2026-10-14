import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/player_controller.dart';
import '../core/mock_data.dart';
import '../model/album_model.dart';
import 'widgets/mini_player_widget.dart';
import 'widgets/song_tile_widget.dart';

class AlbumDetalhesView extends StatelessWidget {
  const AlbumDetalhesView({super.key});

  @override
  Widget build(BuildContext context) {
    final albumArgs = ModalRoute.of(context)?.settings.arguments as AlbumModel?;
    final album = albumArgs ?? MockData.albuns.first;

    final playerCtrl = GetIt.I.get<PlayerController>();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    album.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          album.gradienteCapa.first,
                          album.gradienteCapa.last,
                          const Color(0xFF0F0F0F),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: album.gradienteCapa,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(album.icone, size: 64, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            album.artista,
                            style: const TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Álbum • ${album.ano} • ${album.totalFaixas} músicas • ${album.duracaoTotalFormatada}',
                            style: const TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded, size: 24),
                          label: const Text('Tocar'),
                          onPressed: () {
                            if (album.faixas.isNotEmpty) {
                              playerCtrl.tocarMusica(album.faixas.first, album.faixas);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF444444)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.shuffle_rounded, size: 20),
                          label: const Text('Aleatório'),
                          onPressed: () {
                            if (album.faixas.isNotEmpty) {
                              playerCtrl.alternarShuffle();
                              playerCtrl.tocarMusica(album.faixas.first, album.faixas);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    album.descricao,
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final faixa = album.faixas[index];
                    return SongTileWidget(
                      musica: faixa,
                      listaContexto: album.faixas,
                      numeroFaixa: index + 1,
                    );
                  },
                  childCount: album.faixas.length,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 90),
              ),
            ],
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayerWidget(),
          ),
        ],
      ),
    );
  }
}
