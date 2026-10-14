import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/library_controller.dart';
import '../controller/player_controller.dart';
import '../model/playlist_model.dart';
import 'widgets/song_tile_widget.dart';

class BibliotecaView extends StatefulWidget {
  const BibliotecaView({super.key});

  @override
  State<BibliotecaView> createState() => _BibliotecaViewState();
}

class _BibliotecaViewState extends State<BibliotecaView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _libCtrl = GetIt.I.get<LibraryController>();
  final _playerCtrl = GetIt.I.get<PlayerController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _abrirDialogoNovaPlaylist() {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141414),
          title: const Text('Nova Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Título da playlist *',
                  hintText: 'Ex: Minhas Favoritas',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Ex: Para escutar viajando',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final sucesso = _libCtrl.criarPlaylist(
                  tituloCtrl.text,
                  descCtrl.text,
                );
                if (sucesso) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Playlist criada com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe um título válido.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _libCtrl,
      builder: (context, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sua Biblioteca',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add, color: Colors.white),
                    tooltip: 'Criar Playlist',
                    onPressed: _abrirDialogoNovaPlaylist,
                  ),
                ],
              ),
            ),

            TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF7A7A7A),
              tabs: [
                Tab(
                  text: 'Playlists (${_libCtrl.playlists.length})',
                ),
                Tab(
                  text: 'Curtidas (${_libCtrl.totalCurtidas})',
                ),
                Tab(
                  text: 'Histórico (${_libCtrl.historico.length})',
                ),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAbaPlaylists(),
                  _buildAbaCurtidas(),
                  _buildAbaHistorico(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAbaPlaylists() {
    if (_libCtrl.playlists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.playlist_remove, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('Nenhuma playlist cadastrada.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _abrirDialogoNovaPlaylist,
              child: const Text('Criar Primeira Playlist'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _libCtrl.playlists.length,
      itemBuilder: (context, index) {
        final playlist = _libCtrl.playlists[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: playlist.gradienteCapa,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(playlist.icone, color: Colors.white, size: 28),
          ),
          title: Text(
            playlist.titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            '${playlist.totalFaixas} faixas • ${playlist.duracaoTotalFormatada}',
            style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
          ),
          trailing: playlist.isPersonalizada
              ? IconButton(
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFAAAAAA)),
                  onPressed: () {
                    _libCtrl.excluirPlaylist(playlist.id);
                  },
                )
              : const Icon(Icons.chevron_right, color: Color(0xFFAAAAAA)),
          onTap: () {
            _mostrarDetalhesModal(playlist);
          },
        );
      },
    );
  }

  Widget _buildAbaCurtidas() {
    final curtidas = _libCtrl.musicasCurtidas;

    if (curtidas.isEmpty) {
      return const Center(
        child: Text(
          'Você ainda não curtiu nenhuma música.',
          style: TextStyle(color: Color(0xFFAAAAAA)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: curtidas.length,
      itemBuilder: (context, index) {
        final musica = curtidas[index];
        return SongTileWidget(
          musica: musica,
          listaContexto: curtidas,
          numeroFaixa: index + 1,
        );
      },
    );
  }

  Widget _buildAbaHistorico() {
    final hist = _libCtrl.historico;

    if (hist.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum histórico recente.',
          style: TextStyle(color: Color(0xFFAAAAAA)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: hist.length,
      itemBuilder: (context, index) {
        final musica = hist[index];
        return SongTileWidget(
          musica: musica,
          listaContexto: hist,
          numeroFaixa: index + 1,
        );
      },
    );
  }

  void _mostrarDetalhesModal(PlaylistModel playlist) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: playlist.gradienteCapa,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(playlist.icone, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playlist.titulo,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              playlist.descricao,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFAAAAAA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (playlist.faixas.isNotEmpty)
                        IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFF0000),
                          ),
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          onPressed: () {
                            _playerCtrl.tocarMusica(
                              playlist.faixas.first,
                              playlist.faixas,
                            );
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF333333), height: 24),
                Expanded(
                  child: playlist.faixas.isEmpty
                      ? const Center(
                          child: Text(
                            'Esta playlist ainda está vazia.',
                            style: TextStyle(color: Color(0xFFAAAAAA)),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: playlist.faixas.length,
                          itemBuilder: (context, index) {
                            final faixa = playlist.faixas[index];
                            return SongTileWidget(
                              musica: faixa,
                              listaContexto: playlist.faixas,
                              numeroFaixa: index + 1,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
