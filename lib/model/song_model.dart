import 'package:flutter/material.dart';

class SongModel {
  final String id;
  final String titulo;
  final String artista;
  final String album;
  final Duration duracao;
  final List<Color> gradienteCapa;
  final IconData icone;
  final String letra;
  final String genero;
  bool isCurtida;

  SongModel({
    required this.id,
    required this.titulo,
    required this.artista,
    required this.album,
    required this.duracao,
    required this.gradienteCapa,
    required this.icone,
    required this.letra,
    required this.genero,
    this.isCurtida = false,
  });

  String get duracaoFormatada {
    final minutos = duracao.inMinutes;
    final segundos = duracao.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  SongModel copyWith({
    String? id,
    String? titulo,
    String? artista,
    String? album,
    Duration? duracao,
    List<Color>? gradienteCapa,
    IconData? icone,
    String? letra,
    String? genero,
    bool? isCurtida,
  }) {
    return SongModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      artista: artista ?? this.artista,
      album: album ?? this.album,
      duracao: duracao ?? this.duracao,
      gradienteCapa: gradienteCapa ?? this.gradienteCapa,
      icone: icone ?? this.icone,
      letra: letra ?? this.letra,
      genero: genero ?? this.genero,
      isCurtida: isCurtida ?? this.isCurtida,
    );
  }
}
