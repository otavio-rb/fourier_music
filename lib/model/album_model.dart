import 'package:flutter/material.dart';
import 'song_model.dart';

class AlbumModel {
  final String id;
  final String titulo;
  final String artista;
  final int ano;
  final List<Color> gradienteCapa;
  final IconData icone;
  final String descricao;
  final List<SongModel> faixas;

  AlbumModel({
    required this.id,
    required this.titulo,
    required this.artista,
    required this.ano,
    required this.gradienteCapa,
    required this.icone,
    required this.descricao,
    required this.faixas,
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
