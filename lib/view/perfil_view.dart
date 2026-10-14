import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/auth_controller.dart';
import '../core/app_routes.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final _authCtrl = GetIt.I.get<AuthController>();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;

  bool _editando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: _authCtrl.nomeExibicao);
    _emailController = TextEditingController(text: _authCtrl.emailExibicao);
    _telefoneController = TextEditingController(text: _authCtrl.telefoneExibicao);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _cancelarEdicao() {
    setState(() {
      _nomeController.text = _authCtrl.nomeExibicao;
      _telefoneController.text = _authCtrl.telefoneExibicao;
      _editando = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _salvarAlteracoes() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sucesso = _authCtrl.atualizarPerfil(
      _nomeController.text,
      novoTelefone: _telefoneController.text,
    );

    if (sucesso) {
      setState(() {
        _editando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authCtrl.mensagemSucesso ?? 'Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authCtrl.mensagemErro ?? 'Erro ao atualizar dados.'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  void _confirmarLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF212121),
          title: const Text('Encerrar Sessão'),
          content: const Text('Deseja realmente sair da sua conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF0000),
              ),
              onPressed: () {
                _authCtrl.logout();
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil da Conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Sobre o Projeto',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.sobre);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _authCtrl,
          builder: (context, _) {
            if (!_authCtrl.estaAutenticado) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_person_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Acesso Restrito',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Você precisa estar autenticado para acessar o perfil.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFAAAAAA)),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                            (route) => false,
                          );
                        },
                        child: const Text('Fazer Login'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: const Color(0xFF222222),
                            child: Text(
                              _authCtrl.nomeExibicao.isNotEmpty
                                  ? _authCtrl.nomeExibicao[0].toUpperCase()
                                  : 'O',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            _authCtrl.nomeExibicao,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            _authCtrl.emailExibicao,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        TextFormField(
                          controller: _nomeController,
                          enabled: _editando,
                          decoration: InputDecoration(
                            labelText: 'Nome do usuário *',
                            prefixIcon: const Icon(Icons.person_outline),
                            suffixIcon: !_editando
                                ? IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () {
                                      setState(() {
                                        _editando = true;
                                      });
                                    },
                                  )
                                : null,
                            helperText: _editando
                                ? 'Mínimo de 3 caracteres para validação'
                                : null,
                          ),
                          validator: (value) {
                            final val = value?.trim() ?? '';
                            if (val.isEmpty) {
                              return 'O nome é obrigatório.';
                            }
                            if (val.length < 3) {
                              return 'O nome deve conter ao menos 3 caracteres.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'E-mail cadastrado (Somente leitura)',
                            prefixIcon: Icon(Icons.email_outlined),
                            suffixIcon: Icon(Icons.lock, size: 18),
                            helperText:
                                'O e-mail não pode ser alterado por esta tela.',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _telefoneController,
                          enabled: _editando,
                          decoration: const InputDecoration(
                            labelText: 'Telefone de contato',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                        const SizedBox(height: 28),

                        if (_editando) ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: const BorderSide(color: Color(0xFF555555)),
                                  ),
                                  onPressed: _cancelarEdicao,
                                  child: const Text('Cancelar'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _salvarAlteracoes,
                                  child: const Text('Salvar Alterações'),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Editar Perfil'),
                            onPressed: () {
                              setState(() {
                                _editando = true;
                              });
                            },
                          ),
                        ],
                        const SizedBox(height: 24),

                        const Divider(color: Color(0xFF333333)),
                        const SizedBox(height: 12),

                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: const Color(0xFF1E1E1E),
                          leading: const Icon(Icons.info_outline, color: Colors.white),
                          title: const Text('Informações da Build'),
                          subtitle: const Text('Versão e propósito do projeto'),
                          trailing: const Icon(Icons.chevron_right, color: Color(0xFFAAAAAA)),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.sobre);
                          },
                        ),
                        const SizedBox(height: 12),

                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: const Color(0xFF1E1E1E),
                          leading: const Icon(Icons.logout, color: Color(0xFFFF5555)),
                          title: const Text(
                            'Sair da Conta',
                            style: TextStyle(color: Color(0xFFFF5555)),
                          ),
                          onTap: _confirmarLogout,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
