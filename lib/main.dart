import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'core/service_locator.dart';
import 'view/album_detalhes_view.dart';
import 'view/cadastrar_view.dart';
import 'view/esqueceu_senha_view.dart';
import 'view/login_view.dart';
import 'view/perfil_view.dart';
import 'view/player_view.dart';
import 'view/principal_view.dart';
import 'view/sobre_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configurarDependencias();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fourier',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginView(),
        AppRoutes.cadastrar: (context) => const CadastrarView(),
        AppRoutes.esqueceuSenha: (context) => const EsqueceuSenhaView(),
        AppRoutes.principal: (context) => const PrincipalView(),
        AppRoutes.sobre: (context) => const SobreView(),
        AppRoutes.perfil: (context) => const PerfilView(),
        AppRoutes.player: (context) => const PlayerView(),
        AppRoutes.albumDetalhes: (context) => const AlbumDetalhesView(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginView());
      },
    );
  }
}
