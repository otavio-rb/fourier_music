import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_navigator/controller/auth_controller.dart';
import 'package:flutter_navigator/controller/explore_controller.dart';
import 'package:flutter_navigator/controller/library_controller.dart';
import 'package:flutter_navigator/controller/player_controller.dart';
import 'package:flutter_navigator/core/mock_data.dart';

void main() {
  group('AuthController Tests', () {
    test('Validação de e-mail estática', () {
      expect(AuthController.validarFormatoEmail('usuario@email.com'), isTrue);
      expect(AuthController.validarFormatoEmail('email_invalido'), isFalse);
      expect(AuthController.validarFormatoEmail(''), isFalse);
    });

    test('RF001: Login com credenciais válidas', () {
      final authCtrl = AuthController();
      final sucesso = authCtrl.login('usuario@email.com', '123456');

      expect(sucesso, isTrue);
      expect(authCtrl.estaAutenticado, isTrue);
      expect(authCtrl.usuarioAtual, isNotNull);
      expect(authCtrl.nomeExibicao, 'Otávio');
    });

    test('RF001: Login falha com campos vazios ou e-mail inválido', () {
      final authCtrl = AuthController();

      final vazio = authCtrl.login('', '');
      expect(vazio, isFalse);
      expect(authCtrl.mensagemErro, contains('obrigatórios'));

      final formatoInvalido = authCtrl.login('email_sem_arroba', '123456');
      expect(formatoInvalido, isFalse);
      expect(authCtrl.mensagemErro, contains('formato válido'));
    });

    test('RF002: Cadastro de novo usuário com sucesso', () {
      final authCtrl = AuthController();
      final sucesso = authCtrl.cadastrar(
        nome: 'Otávio',
        email: 'novo@email.com',
        telefone: '(11) 91234-5678',
        senha: 'senhaSegura123',
        confirmacaoSenha: 'senhaSegura123',
      );

      expect(sucesso, isTrue);
      expect(authCtrl.estaAutenticado, isTrue);
      expect(authCtrl.nomeExibicao, 'Otávio');
      expect(authCtrl.emailExibicao, 'novo@email.com');
    });

    test('RF002: Cadastro falha se senhas divergirem', () {
      final authCtrl = AuthController();
      final sucesso = authCtrl.cadastrar(
        nome: 'Otávio',
        email: 'teste@email.com',
        telefone: '(11) 91234-5678',
        senha: 'senha123',
        confirmacaoSenha: 'senhaDiferente',
      );

      expect(sucesso, isFalse);
      expect(authCtrl.mensagemErro, contains('não conferem'));
    });

    test('RF003: Recuperação de senha com e-mail válido', () {
      final authCtrl = AuthController();
      final sucesso = authCtrl.recuperarSenha('usuario@email.com');

      expect(sucesso, isTrue);
      expect(authCtrl.mensagemSucesso, contains('usuario@email.com'));
    });

    test('RF005: Atualização de perfil com validação de caracteres', () {
      final authCtrl = AuthController();
      authCtrl.login('usuario@email.com', '123456');

      final falhaMinimo = authCtrl.atualizarPerfil('Oi');
      expect(falhaMinimo, isFalse);
      expect(authCtrl.mensagemErro, contains('no mínimo 3'));

      final sucesso = authCtrl.atualizarPerfil('Otávio');
      expect(sucesso, isTrue);
      expect(authCtrl.nomeExibicao, 'Otávio');
    });
  });

  group('PlayerController & LibraryController Tests', () {
    test('PlayerController alterna reprodução e passa faixas', () {
      final playerCtrl = PlayerController();

      expect(playerCtrl.musicaAtual, isNotNull);
      final primeiraMusica = playerCtrl.musicaAtual!;

      playerCtrl.alternarPlayPause();
      expect(playerCtrl.estaTocando, isTrue);

      playerCtrl.proxima();
      expect(playerCtrl.musicaAtual?.id != primeiraMusica.id, isTrue);
    });

    test('LibraryController cria playlist e gerencia curtidas', () {
      final libCtrl = LibraryController();
      final totalInicial = libCtrl.playlists.length;

      final criada = libCtrl.criarPlaylist('Playlist Teste', 'Descrição Teste');
      expect(criada, isTrue);
      expect(libCtrl.playlists.length, totalInicial + 1);

      final musica = MockData.musicas.first;
      final statusInicial = musica.isCurtida;
      libCtrl.alternarCurtir(musica);
      expect(musica.isCurtida, !statusInicial);
    });

    test('ExploreController filtra músicas por busca e gênero', () {
      final exploreCtrl = ExploreController();
      exploreCtrl.selecionarCategoria('Barroco');
      expect(exploreCtrl.musicasFiltradasPorCategoria.every((m) => m.genero == 'Barroco'), isTrue);

      exploreCtrl.atualizarBusca('Zadok');
      expect(exploreCtrl.resultadoBuscaMusicas.length, 1);
      expect(exploreCtrl.resultadoBuscaMusicas.first.titulo, contains('Zadok'));
    });
  });
}
