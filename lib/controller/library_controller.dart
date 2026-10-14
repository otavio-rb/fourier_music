import 'package:flutter/material.dart';
import '../core/mock_data.dart';
import '../model/playlist_model.dart';
import '../model/song_model.dart';

class LibraryController extends ChangeNotifier {
  final List<PlaylistModel> _playlists = [];
  final List<SongModel> _historico = [];

  LibraryController() {
    _playlists.addAll(MockData.playlists);
    _historico.addAll(MockData.musicas.take(3));
  }

  List<PlaylistModel> get playlists => List.unmodifiable(_playlists);
  List<SongModel> get historico => List.unmodifiable(_historico);

  List<SongModel> get musicasCurtidas {
    return MockData.musicas.where((m) => m.isCurtida).toList();
  }

  int get totalCurtidas => musicasCurtidas.length;

  bool criarPlaylist(String titulo, String descricao) {
    if (titulo.trim().isEmpty) return false;

    final novaPlaylist = PlaylistModel(
      id: 'pl_${DateTime.now().millisecondsSinceEpoch}',
      titulo: titulo.trim(),
      descricao: descricao.trim().isEmpty
          ? 'Criada pelo usuário'
          : descricao.trim(),
      gradienteCapa: [
        Colors.deepPurple,
        Colors.pinkAccent,
      ],
      icone: Icons.queue_music,
      faixas: [],
      isPersonalizada: true,
    );

    _playlists.insert(0, novaPlaylist);
    notifyListeners();
    return true;
  }

  void adicionarAoHistorico(SongModel musica) {
    _historico.removeWhere((item) => item.id == musica.id);
    _historico.insert(0, musica);
    if (_historico.length > 20) {
      _historico.removeLast();
    }
    notifyListeners();
  }

  void alternarCurtir(SongModel musica) {
    musica.isCurtida = !musica.isCurtida;
    notifyListeners();
  }

  void adicionarMusicaAPlaylist(String playlistId, SongModel musica) {
    final playlist = _playlists.firstWhere((p) => p.id == playlistId);
    if (!playlist.faixas.any((f) => f.id == musica.id)) {
      playlist.faixas.add(musica);
      notifyListeners();
    }
  }

  void removerMusicaDaPlaylist(String playlistId, String musicaId) {
    final playlist = _playlists.firstWhere((p) => p.id == playlistId);
    playlist.faixas.removeWhere((f) => f.id == musicaId);
    notifyListeners();
  }

  void excluirPlaylist(String playlistId) {
    _playlists.removeWhere((p) => p.id == playlistId);
    notifyListeners();
  }
}
