import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/auth_controller.dart';
import '../controller/explore_controller.dart';
import '../controller/player_controller.dart';
import '../core/mock_data.dart';
import '../model/song_model.dart';
import 'widgets/album_card_widget.dart';
import 'widgets/song_tile_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _playerCtrl = GetIt.I.get<PlayerController>();
  final _authCtrl = GetIt.I.get<AuthController>();
  final _exploreCtrl = GetIt.I.get<ExploreController>();

  String _filtroSelecionado = 'Tudo';

  final List<String> _filtrosRapidos = const [
    'Tudo',
    'Foco & Estudo',
    'Relaxar & Noite',
    'Barroco',
    'Piano Solo',
    'Orquestral',
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_authCtrl, _exploreCtrl]),
      builder: (context, _) {
        final saudacao = _obterSaudacao();
        final musicasExibicao = _filtrarMusicasPorHumor(_filtroSelecionado);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$saudacao, ${_authCtrl.nomeExibicao}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filtrosRapidos.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filtro = _filtrosRapidos[index];
                    final isSelected = _filtroSelecionado == filtro;

                    return FilterChip(
                      selected: isSelected,
                      showCheckmark: false,
                      label: Text(filtro),
                      onSelected: (selected) {
                        setState(() {
                          _filtroSelecionado = filtro;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ouvir novamente',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _playerCtrl.tocarMusica(musicasExibicao.first, musicasExibicao);
                      },
                      child: const Text('Tocar tudo'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: musicasExibicao.length,
                  itemBuilder: (context, index) {
                    final musica = musicasExibicao[index];
                    return _buildSongCard(musica, musicasExibicao);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: Text(
                  'Álbuns em destaque',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 205,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: MockData.albuns.length,
                  itemBuilder: (context, index) {
                    final album = MockData.albuns[index];
                    return AlbumCardWidget(album: album);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 28, 16, 8),
                child: Text(
                  'Mais Tocadas no Momento',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final musica = MockData.musicas[index];
                  return SongTileWidget(
                    musica: musica,
                    listaContexto: MockData.musicas,
                    numeroFaixa: index + 1,
                  );
                },
                childCount: MockData.musicas.length,
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

  Widget _buildSongCard(SongModel musica, List<SongModel> fila) {
    return GestureDetector(
      onTap: () {
        _playerCtrl.tocarMusica(musica, fila);
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: musica.gradienteCapa,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    musica.icone,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              musica.titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              musica.artista,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _obterSaudacao() {
    final hora = DateTime.now().hour;
    if (hora < 12) {
      return 'Bom dia';
    } else if (hora < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  List<SongModel> _filtrarMusicasPorHumor(String humor) {
    switch (humor) {
      case 'Foco & Estudo':
      case 'Barroco':
        return MockData.musicas
            .where((m) => m.artista.contains('Bach') || m.genero == 'Barroco')
            .toList();
      case 'Relaxar & Noite':
      case 'Piano Solo':
        return MockData.musicas
            .where((m) => m.artista.contains('Chopin') || m.genero == 'Piano Solo')
            .toList();
      case 'Orquestral':
        return MockData.musicas
            .where((m) =>
                m.artista.contains('Händel') ||
                m.genero == 'Orquestral' ||
                m.genero == 'Coral & Ópera')
            .toList();
      default:
        return MockData.musicas;
    }
  }
}
