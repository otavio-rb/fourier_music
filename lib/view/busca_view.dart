import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/explore_controller.dart';
import 'widgets/song_tile_widget.dart';

class BuscaView extends StatefulWidget {
  const BuscaView({super.key});

  @override
  State<BuscaView> createState() => _BuscaViewState();
}

class _BuscaViewState extends State<BuscaView> {
  final _exploreCtrl = GetIt.I.get<ExploreController>();
  late final TextEditingController _buscaController;

  @override
  void initState() {
    super.initState();
    _buscaController = TextEditingController(text: _exploreCtrl.termoBusca);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _exploreCtrl,
      builder: (context, _) {
        final resultados = _exploreCtrl.resultadoBuscaMusicas;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _buscaController,
                decoration: InputDecoration(
                  hintText: 'Pesquise músicas, artistas ou álbuns',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFAAAAAA)),
                  suffixIcon: _buscaController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color(0xFFAAAAAA)),
                          onPressed: () {
                            _buscaController.clear();
                            _exploreCtrl.limparBusca();
                          },
                        )
                      : null,
                ),
                onChanged: (valor) {
                  _exploreCtrl.atualizarBusca(valor);
                },
              ),
            ),

            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _exploreCtrl.filtrosTipo.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filtro = _exploreCtrl.filtrosTipo[index];
                  final isSelected = _exploreCtrl.filtroTipoBusca == filtro;

                  return FilterChip(
                    selected: isSelected,
                    label: Text(filtro),
                    onSelected: (selected) {
                      _exploreCtrl.selecionarFiltroTipo(filtro);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: resultados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhum resultado para "${_exploreCtrl.termoBusca}"',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        final musica = resultados[index];
                        return SongTileWidget(
                          musica: musica,
                          listaContexto: resultados,
                          numeroFaixa: index + 1,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
