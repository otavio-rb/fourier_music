import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/library_controller.dart';
import '../controller/player_controller.dart';
import '../model/song_model.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  final _playerCtrl = GetIt.I.get<PlayerController>();
  final _libCtrl = GetIt.I.get<LibraryController>();

  int _modoVisualizacao = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_playerCtrl, _libCtrl]),
      builder: (context, _) {
        final musica = _playerCtrl.musicaAtual;

        if (musica == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Player')),
            body: const Center(
              child: Text(
                'Nenhuma música selecionada.',
                style: TextStyle(color: Color(0xFF888888)),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0C0C0C),
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(musica),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildConteudoAtivo(musica),
                  ),
                ),
                _buildBottomSwitchBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(SongModel musica) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _modoVisualizacao == 1
                      ? 'LETRAS'
                      : _modoVisualizacao == 2
                          ? 'FILA DE REPRODUÇÃO'
                          : 'TOCANDO AGORA',
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  musica.album,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              musica.isCurtida ? Icons.favorite : Icons.favorite_border_rounded,
              color: musica.isCurtida ? const Color(0xFFFF334B) : const Color(0xFF888888),
              size: 24,
            ),
            onPressed: () {
              _libCtrl.alternarCurtir(musica);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConteudoAtivo(SongModel musica) {
    switch (_modoVisualizacao) {
      case 1:
        return _buildLetrasView(musica);
      case 2:
        return _buildFilaView();
      default:
        return _buildPlayerPrincipal(musica);
    }
  }

  Widget _buildPlayerPrincipal(SongModel musica) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tamanhoCapa = (constraints.maxHeight * 0.46).clamp(200.0, 320.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: tamanhoCapa,
                height: tamanhoCapa,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: musica.gradienteCapa,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    musica.icone,
                    size: tamanhoCapa * 0.35,
                    color: Colors.white,
                  ),
                ),
              ),

              Column(
                children: [
                  Text(
                    musica.titulo,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    musica.artista,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Color(0xFF262626),
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: _playerCtrl.progressoPercentual,
                      onChanged: (novoValor) {
                        final ms = (novoValor * _playerCtrl.duracaoTotal.inMilliseconds).round();
                        _playerCtrl.seek(Duration(milliseconds: ms));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _playerCtrl.posicaoFormatada,
                          style: const TextStyle(
                            color: Color(0xFF7A7A7A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _playerCtrl.duracaoFormatada,
                          style: const TextStyle(
                            color: Color(0xFF7A7A7A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shuffle_rounded,
                      color: _playerCtrl.shuffle
                          ? const Color(0xFFFF334B)
                          : const Color(0xFF6E6E6E),
                      size: 22,
                    ),
                    onPressed: _playerCtrl.alternarShuffle,
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                    onPressed: _playerCtrl.anterior,
                  ),

                  GestureDetector(
                    onTap: _playerCtrl.alternarPlayPause,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          _playerCtrl.estaTocando
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 38,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                    onPressed: _playerCtrl.proxima,
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.repeat_rounded,
                      color: _playerCtrl.repeat
                          ? const Color(0xFFFF334B)
                          : const Color(0xFF6E6E6E),
                      size: 22,
                    ),
                    onPressed: _playerCtrl.alternarRepeat,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLetrasView(SongModel musica) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            musica.titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            musica.artista,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            musica.letra,
            style: const TextStyle(
              fontSize: 19,
              height: 1.9,
              fontWeight: FontWeight.w500,
              color: Color(0xFFDDDDDD),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFilaView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _playerCtrl.fila.length,
      itemBuilder: (context, index) {
        final musicaFila = _playerCtrl.fila[index];
        final isAtual = _playerCtrl.musicaAtual?.id == musicaFila.id;

        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: isAtual ? const Color(0xFF1A1A1A) : Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: musicaFila.gradienteCapa),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isAtual && _playerCtrl.estaTocando
                  ? Icons.graphic_eq_rounded
                  : musicaFila.icone,
              color: Colors.white,
              size: 22,
            ),
          ),
          title: Text(
            musicaFila.titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isAtual ? const Color(0xFFFF334B) : Colors.white,
              fontWeight: isAtual ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            musicaFila.artista,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 12,
            ),
          ),
          trailing: Text(
            musicaFila.duracaoFormatada,
            style: const TextStyle(
              color: Color(0xFF6E6E6E),
              fontSize: 12,
            ),
          ),
          onTap: () {
            _playerCtrl.tocarMusica(musicaFila, _playerCtrl.fila);
          },
        );
      },
    );
  }

  Widget _buildBottomSwitchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPillTab(0, 'Música', Icons.music_note_rounded),
          const SizedBox(width: 8),
          _buildPillTab(1, 'Letras', Icons.lyrics_outlined),
          const SizedBox(width: 8),
          _buildPillTab(2, 'Fila', Icons.queue_music_rounded),
        ],
      ),
    );
  }

  Widget _buildPillTab(int modo, String label, IconData icone) {
    final ativo = _modoVisualizacao == modo;

    return GestureDetector(
      onTap: () {
        setState(() {
          _modoVisualizacao = modo;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: ativo ? Colors.white : const Color(0xFF181818),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              size: 15,
              color: ativo ? Colors.black : const Color(0xFF8E8E93),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: ativo ? FontWeight.bold : FontWeight.w500,
                color: ativo ? Colors.black : const Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
