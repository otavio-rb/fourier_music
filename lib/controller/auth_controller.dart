import 'package:flutter/material.dart';
import '../model/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _usuarioAtual;
  bool _estaAutenticado = false;
  bool _carregando = false;
  String? _mensagemErro;
  String? _mensagemSucesso;

  final Map<String, Map<String, String>> _usuariosCadastrados = {
    'usuario@email.com': {
      'nome': 'Otávio',
      'senha': '123456',
      'telefone': '(16) 99876-5432',
    },
    'demo@musica.com': {
      'nome': 'Alex Silva',
      'senha': '123456',
      'telefone': '(11) 98765-4321',
    },
  };

  UserModel? get usuarioAtual => _usuarioAtual;
  bool get estaAutenticado => _estaAutenticado;
  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;
  String? get mensagemSucesso => _mensagemSucesso;

  String get nomeExibicao => _usuarioAtual?.nome ?? 'Visitante';
  String get emailExibicao => _usuarioAtual?.email ?? 'Não informado';
  String get telefoneExibicao => _usuarioAtual?.telefone ?? 'Não informado';

  static bool validarFormatoEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email.trim());
  }

  void limparMensagens() {
    _mensagemErro = null;
    _mensagemSucesso = null;
    notifyListeners();
  }

  bool login(String email, String senha) {
    _carregando = true;
    _mensagemErro = null;
    _mensagemSucesso = null;
    notifyListeners();

    final emailFormatado = email.trim();
    final senhaFormatada = senha.trim();

    if (emailFormatado.isEmpty || senhaFormatada.isEmpty) {
      _mensagemErro = 'Preencha todos os campos obrigatórios.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    if (!validarFormatoEmail(emailFormatado)) {
      _mensagemErro = 'Por favor, informe um e-mail com formato válido.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    if (_usuariosCadastrados.containsKey(emailFormatado.toLowerCase())) {
      final userDados = _usuariosCadastrados[emailFormatado.toLowerCase()]!;
      if (userDados['senha'] != senhaFormatada) {
        _mensagemErro = 'Senha incorreta para o e-mail informado.';
        _carregando = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        nome: userDados['nome']!,
        email: emailFormatado,
        telefone: userDados['telefone']!,
      );
    } else {
      if (senhaFormatada.length < 6) {
        _mensagemErro = 'A senha deve conter no mínimo 6 caracteres.';
        _carregando = false;
        notifyListeners();
        return false;
      }

      _usuarioAtual = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        nome: emailFormatado.split('@').first.replaceAll('.', ' ').toUpperCase(),
        email: emailFormatado,
        telefone: '(11) 99999-9999',
      );
      _usuariosCadastrados[emailFormatado.toLowerCase()] = {
        'nome': _usuarioAtual!.nome,
        'senha': senhaFormatada,
        'telefone': _usuarioAtual!.telefone,
      };
    }

    _estaAutenticado = true;
    _mensagemSucesso = 'Autenticado com sucesso!';
    _carregando = false;
    notifyListeners();
    return true;
  }

  bool cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
    required String confirmacaoSenha,
  }) {
    _carregando = true;
    _mensagemErro = null;
    _mensagemSucesso = null;
    notifyListeners();

    final nomeFormatado = nome.trim();
    final emailFormatado = email.trim();
    final telefoneFormatado = telefone.trim();
    final senhaFormatada = senha.trim();
    final confirmacaoFormatada = confirmacaoSenha.trim();

    if (nomeFormatado.isEmpty ||
        emailFormatado.isEmpty ||
        telefoneFormatado.isEmpty ||
        senhaFormatada.isEmpty ||
        confirmacaoFormatada.isEmpty) {
      _mensagemErro = 'Todos os campos são obrigatórios.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    if (!validarFormatoEmail(emailFormatado)) {
      _mensagemErro = 'O e-mail informado não possui um formato válido.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    if (senhaFormatada.length < 6) {
      _mensagemErro = 'A senha deve conter pelo menos 6 caracteres.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    if (senhaFormatada != confirmacaoFormatada) {
      _mensagemErro = 'As senhas informadas não conferem.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _usuariosCadastrados[emailFormatado.toLowerCase()] = {
      'nome': nomeFormatado,
      'senha': senhaFormatada,
      'telefone': telefoneFormatado,
    };

    _usuarioAtual = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      nome: nomeFormatado,
      email: emailFormatado,
      telefone: telefoneFormatado,
    );

    _estaAutenticado = true;
    _mensagemSucesso = 'Cadastro realizado com sucesso! Bem-vindo ao Fourier.';
    _carregando = false;
    notifyListeners();
    return true;
  }

  bool solicitarRecuperacaoSenha(String email) {
    _carregando = true;
    _mensagemErro = null;
    _mensagemSucesso = null;
    notifyListeners();

    final emailFormatado = email.trim();

    if (emailFormatado.isEmpty) {
      _mensagemErro = 'Por favor, informe seu e-mail cadastrado.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    if (!validarFormatoEmail(emailFormatado)) {
      _mensagemErro = 'O e-mail digitado não possui um formato válido.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _mensagemSucesso =
        'Instruções de redefinição de senha foram enviadas para: $emailFormatado';
    _carregando = false;
    notifyListeners();
    return true;
  }

  bool recuperarSenha(String email) => solicitarRecuperacaoSenha(email);

  bool atualizarPerfil(String novoNome, {String? novoTelefone}) {
    _carregando = true;
    _mensagemErro = null;
    _mensagemSucesso = null;
    notifyListeners();

    if (_usuarioAtual == null) {
      _mensagemErro = 'Nenhum usuário autenticado.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    final nomeFormatado = novoNome.trim();

    if (nomeFormatado.isEmpty) {
      _mensagemErro = 'O nome de usuário não pode ficar em branco.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    if (nomeFormatado.length < 3) {
      _mensagemErro = 'O nome deve conter no mínimo 3 caracteres.';
      _carregando = false;
      notifyListeners();
      return false;
    }

    _usuarioAtual!.nome = nomeFormatado;
    if (novoTelefone != null && novoTelefone.trim().isNotEmpty) {
      _usuarioAtual!.telefone = novoTelefone.trim();
    }

    if (_usuariosCadastrados.containsKey(_usuarioAtual!.email.toLowerCase())) {
      _usuariosCadastrados[_usuarioAtual!.email.toLowerCase()]!['nome'] = nomeFormatado;
      if (novoTelefone != null && novoTelefone.trim().isNotEmpty) {
        _usuariosCadastrados[_usuarioAtual!.email.toLowerCase()]!['telefone'] =
            novoTelefone.trim();
      }
    }

    _mensagemSucesso = 'Perfil atualizado com sucesso!';
    _carregando = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _usuarioAtual = null;
    _estaAutenticado = false;
    _mensagemErro = null;
    _mensagemSucesso = null;
    notifyListeners();
  }
}
