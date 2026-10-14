import 'dart:async';
import 'package:flutter/material.dart';
import '../core/mock_data.dart';
import '../model/song_model.dart';

class PlayerController extends ChangeNotifier {
  SongModel? _musicaAtual;
  bool _estaTocando = false;
  Duration _posicaoAtual = Duration.zero;
  Duration _duracaoTotal = const Duration(minutes: 3, seconds: 30);
  List<SongModel> _fila = [];
  int _indiceAtual = 0;
  bool _shuffle = false;
  bool _repeat = false;

  Timer? _timerProgresso;

  PlayerController() {
    _fila = List.from(MockData.musicas);
    if (_fila.isNotEmpty) {
      _musicaAtual = _fila.first;
      _duracaoTotal = _musicaAtual!.duracao;
    }
  }

  SongModel? get musicaAtual => _musicaAtual;
  bool get estaTocando => _estaTocando;
  Duration get posicaoAtual => _posicaoAtual;
  Duration get duracaoTotal => _duracaoTotal;
  List<SongModel> get fila => List.unmodifiable(_fila);
  int get indiceAtual => _indiceAtual;
  bool get shuffle => _shuffle;
  bool get repeat => _repeat;

  double get progressoPercentual {
    if (_duracaoTotal.inMilliseconds == 0) return 0.0;
    return (_posicaoAtual.inMilliseconds / _duracaoTotal.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  String get posicaoFormatada {
    final minutos = _posicaoAtual.inMinutes;
    final segundos =
        _posicaoAtual.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  String get duracaoFormatada {
    final minutos = _duracaoTotal.inMinutes;
    final segundos =
        _duracaoTotal.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  void tocarMusica(SongModel musica, [List<SongModel>? novaFila]) {
    if (novaFila != null && novaFila.isNotEmpty) {
      _fila = List.from(novaFila);
      _indiceAtual = _fila.indexWhere((m) => m.id == musica.id);
      if (_indiceAtual == -1) {
        _fila.insert(0, musica);
        _indiceAtual = 0;
      }
    } else {
      final index = _fila.indexWhere((m) => m.id == musica.id);
      if (index != -1) {
        _indiceAtual = index;
      } else {
        _fila.add(musica);
        _indiceAtual = _fila.length - 1;
      }
    }

    _musicaAtual = musica;
    _duracaoTotal = musica.duracao;
    _posicaoAtual = Duration.zero;
    _estaTocando = true;

    _iniciarTimerProgresso();
    notifyListeners();
  }

  void alternarPlayPause() {
    if (_musicaAtual == null && _fila.isNotEmpty) {
      tocarMusica(_fila.first);
      return;
    }

    _estaTocando = !_estaTocando;
    if (_estaTocando) {
      _iniciarTimerProgresso();
    } else {
      _pararTimerProgresso();
    }
    notifyListeners();
  }

  void proxima() {
    if (_fila.isEmpty) return;

    if (_shuffle) {
      _indiceAtual = (_indiceAtual + 2) % _fila.length;
    } else {
      _indiceAtual = (_indiceAtual + 1) % _fila.length;
    }

    _musicaAtual = _fila[_indiceAtual];
    _duracaoTotal = _musicaAtual!.duracao;
    _posicaoAtual = Duration.zero;
    _estaTocando = true;

    _iniciarTimerProgresso();
    notifyListeners();
  }

  void anterior() {
    if (_fila.isEmpty) return;

    if (_posicaoAtual.inSeconds > 3) {
      _posicaoAtual = Duration.zero;
      notifyListeners();
      return;
    }

    _indiceAtual = (_indiceAtual - 1 + _fila.length) % _fila.length;
    _musicaAtual = _fila[_indiceAtual];
    _duracaoTotal = _musicaAtual!.duracao;
    _posicaoAtual = Duration.zero;
    _estaTocando = true;

    _iniciarTimerProgresso();
    notifyListeners();
  }

  void seek(Duration novaPosicao) {
    _posicaoAtual = novaPosicao;
    if (_posicaoAtual > _duracaoTotal) {
      _posicaoAtual = _duracaoTotal;
    }
    notifyListeners();
  }

  void alternarShuffle() {
    _shuffle = !_shuffle;
    notifyListeners();
  }

  void alternarRepeat() {
    _repeat = !_repeat;
    notifyListeners();
  }

  void alternarCurtirAtual() {
    if (_musicaAtual == null) return;
    _musicaAtual!.isCurtida = !_musicaAtual!.isCurtida;
    notifyListeners();
  }

  void _iniciarTimerProgresso() {
    _pararTimerProgresso();
    _timerProgresso = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_estaTocando) {
        timer.cancel();
        return;
      }

      if (_posicaoAtual < _duracaoTotal) {
        _posicaoAtual += const Duration(seconds: 1);
        notifyListeners();
      } else {
        if (_repeat) {
          _posicaoAtual = Duration.zero;
          notifyListeners();
        } else {
          proxima();
        }
      }
    });
  }

  void _pararTimerProgresso() {
    _timerProgresso?.cancel();
    _timerProgresso = null;
  }

  @override
  void dispose() {
    _pararTimerProgresso();
    super.dispose();
  }
}
