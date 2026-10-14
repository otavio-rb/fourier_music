import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../controller/library_controller.dart';
import '../../controller/player_controller.dart';
import '../../model/song_model.dart';

class SongTileWidget extends StatelessWidget {
  final SongModel musica;
  final List<SongModel>? listaContexto;
  final int? numeroFaixa;
  final VoidCallback? onLongPress;

  const SongTileWidget({
    super.key,
    required this.musica,
    this.listaContexto,
    this.numeroFaixa,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final playerCtrl = GetIt.I.get<PlayerController>();
    final libCtrl = GetIt.I.get<LibraryController>();

    return ListenableBuilder(
      listenable: Listenable.merge([playerCtrl, libCtrl]),
      builder: (context, _) {
        final estaTocandoEstaMusica =
            playerCtrl.musicaAtual?.id == musica.id && playerCtrl.estaTocando;
        final isSelecionada = playerCtrl.musicaAtual?.id == musica.id;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (numeroFaixa != null) ...[
                SizedBox(
                  width: 24,
                  child: Text(
                    '$numeroFaixa',
                    style: TextStyle(
                      color: isSelecionada
                          ? const Color(0xFFFF2A55)
                          : const Color(0xFFAAAAAA),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: musica.gradienteCapa,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  estaTocandoEstaMusica
                      ? Icons.graphic_eq_rounded
                      : musica.icone,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          title: Text(
            musica.titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelecionada ? const Color(0xFFFF2A55) : Colors.white,
              fontWeight: isSelecionada ? FontWeight.bold : FontWeight.w500,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            '${musica.artista} • ${musica.duracaoFormatada}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 13,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  musica.isCurtida
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  color: musica.isCurtida ? const Color(0xFFFF2A55) : const Color(0xFFAAAAAA),
                  size: 22,
                ),
                onPressed: () {
                  libCtrl.alternarCurtir(musica);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFFAAAAAA),
                  size: 20,
                ),
                onPressed: () {
                  _mostrarOpcoesMusica(context, musica, libCtrl);
                },
              ),
            ],
          ),
          onTap: () {
            playerCtrl.tocarMusica(musica, listaContexto);
            libCtrl.adicionarAoHistorico(musica);
          },
          onLongPress: onLongPress,
        );
      },
    );
  }

  void _mostrarOpcoesMusica(
    BuildContext context,
    SongModel musica,
    LibraryController libCtrl,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: musica.gradienteCapa,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(musica.icone, color: Colors.white),
                  ),
                  title: Text(
                    musica.titulo,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  subtitle: Text(
                    musica.artista,
                    style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
                  ),
                ),
                const Divider(color: Color(0xFF222222)),
                ListTile(
                  leading: const Icon(Icons.playlist_add),
                  title: const Text('Adicionar à playlist'),
                  onTap: () {
                    Navigator.pop(context);
                    _mostrarDialogoAdicionarPlaylist(context, musica, libCtrl);
                  },
                ),
                ListTile(
                  leading: Icon(
                    musica.isCurtida ? Icons.favorite : Icons.favorite_border,
                  ),
                  title: Text(
                    musica.isCurtida
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                  ),
                  onTap: () {
                    libCtrl.alternarCurtir(musica);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarDialogoAdicionarPlaylist(
    BuildContext context,
    SongModel musica,
    LibraryController libCtrl,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF212121),
          title: const Text('Escolha uma Playlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: libCtrl.playlists.isEmpty
                ? const Text('Nenhuma playlist criada ainda.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: libCtrl.playlists.length,
                    itemBuilder: (context, index) {
                      final p = libCtrl.playlists[index];
                      return ListTile(
                        leading: const Icon(Icons.queue_music, color: Colors.white),
                        title: Text(p.titulo),
                        subtitle: Text('${p.totalFaixas} faixas'),
                        onTap: () {
                          libCtrl.adicionarMusicaAPlaylist(p.id, musica);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Música adicionada à playlist "${p.titulo}"!',
                              ),
                              backgroundColor: const Color(0xFF333333),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
