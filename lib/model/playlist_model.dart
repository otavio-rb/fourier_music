import 'package:flutter/material.dart';
import 'song_model.dart';

class PlaylistModel {
  final String id;
  String titulo;
  String descricao;
  final List<Color> gradienteCapa;
  final IconData icone;
  final List<SongModel> faixas;
  final bool isPersonalizada;

  PlaylistModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.gradienteCapa,
    this.icone = Icons.queue_music,
    required this.faixas,
    this.isPersonalizada = false,
  });

  int get totalFaixas => faixas.length;

  Duration get duracaoTotal {
    return faixas.fold(
      Duration.zero,
      (previousValue, song) => previousValue + song.duracao,
    );
  }

  String get duracaoTotalFormatada {
    final minutos = duracaoTotal.inMinutes;
    return '$minutos min';
  }
}
