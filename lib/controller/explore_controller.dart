import 'package:flutter/material.dart';
import '../core/mock_data.dart';
import '../model/album_model.dart';
import '../model/song_model.dart';

class ExploreController extends ChangeNotifier {
  String _categoriaSelecionada = 'Todos';
  String _termoBusca = '';
  String _filtroTipoBusca = 'Todas';

  final List<String> _filtrosTipo = ['Todas', 'Músicas', 'Artistas', 'Álbuns'];

  String get categoriaSelecionada => _categoriaSelecionada;
  String get termoBusca => _termoBusca;
  String get filtroTipoBusca => _filtroTipoBusca;
  List<String> get filtrosTipo => _filtrosTipo;

  List<SongModel> get musicasFiltradasPorCategoria {
    if (_categoriaSelecionada == 'Todos') {
      return MockData.musicas;
    }
    return MockData.musicas
        .where((m) =>
            m.genero.toLowerCase() == _categoriaSelecionada.toLowerCase())
        .toList();
  }

  List<SongModel> get resultadoBuscaMusicas {
    final query = _termoBusca.trim().toLowerCase();
    if (query.isEmpty) {
      return MockData.musicas;
    }

    return MockData.musicas.where((m) {
      final matchTitulo = m.titulo.toLowerCase().contains(query);
      final matchArtista = m.artista.toLowerCase().contains(query);
      final matchAlbum = m.album.toLowerCase().contains(query);

      if (_filtroTipoBusca == 'Músicas') {
        return matchTitulo;
      } else if (_filtroTipoBusca == 'Artistas') {
        return matchArtista;
      } else if (_filtroTipoBusca == 'Álbuns') {
        return matchAlbum;
      }
      return matchTitulo || matchArtista || matchAlbum;
    }).toList();
  }

  List<AlbumModel> get albunsRecomendados => MockData.albuns;

  void selecionarCategoria(String categoria) {
    _categoriaSelecionada = categoria;
    notifyListeners();
  }

  void atualizarBusca(String termo) {
    _termoBusca = termo;
    notifyListeners();
  }

  void selecionarFiltroTipo(String tipo) {
    _filtroTipoBusca = tipo;
    notifyListeners();
  }

  void limparBusca() {
    _termoBusca = '';
    notifyListeners();
  }
}
