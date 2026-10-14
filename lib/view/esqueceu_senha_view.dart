import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/auth_controller.dart';

class EsqueceuSenhaView extends StatefulWidget {
  const EsqueceuSenhaView({super.key});

  @override
  State<EsqueceuSenhaView> createState() => _EsqueceuSenhaViewState();
}

class _EsqueceuSenhaViewState extends State<EsqueceuSenhaView> {
  final _authCtrl = GetIt.I.get<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _solicitacaoEnviada = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _solicitarRecuperacao() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sucesso = _authCtrl.recuperarSenha(_emailController.text);

    if (sucesso) {
      setState(() {
        _solicitacaoEnviada = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authCtrl.mensagemSucesso ?? 'E-mail de recuperação enviado!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authCtrl.mensagemErro ?? 'Erro ao solicitar recuperação.'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperação de Senha'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _solicitacaoEnviada
                  ? _buildSucessoCard()
                  : _buildFormulario(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Esqueceu sua senha?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Informe o endereço de e-mail associado à sua conta e enviaremos instruções detalhadas para redefinição.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFAAAAAA),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-mail cadastrado *',
              hintText: 'seu.email@exemplo.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              final val = value?.trim() ?? '';
              if (val.isEmpty) {
                return 'Informe o e-mail.';
              }
              if (!AuthController.validarFormatoEmail(val)) {
                return 'Informe um e-mail com formato válido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: _authCtrl,
            builder: (context, _) {
              return ElevatedButton(
                onPressed:
                    _authCtrl.carregando ? null : _solicitarRecuperacao,
                child: _authCtrl.carregando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Recuperar Senha'),
              );
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back, size: 18),
              onPressed: () => Navigator.pop(context),
              label: const Text('Voltar para o Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSucessoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A24),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: Colors.greenAccent,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'E-mail Enviado com Sucesso!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'As instruções para redefinição da sua senha foram enviadas para:\n${_emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFAAAAAA),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Retornar ao Login'),
        ),
      ],
    );
  }
}
