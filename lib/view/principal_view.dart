import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/auth_controller.dart';
import '../core/app_routes.dart';
import 'biblioteca_view.dart';
import 'busca_view.dart';
import 'explorar_view.dart';
import 'home_view.dart';
import 'widgets/mini_player_widget.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  int _indiceAba = 0;
  final _authCtrl = GetIt.I.get<AuthController>();

  final List<Widget> _telas = const [
    HomeView(),
    ExplorarView(),
    BibliotecaView(),
    BuscaView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authCtrl,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF334B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'ω',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Fourier',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Informações da Build',
                icon: const Icon(Icons.info_outline, size: 22),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.sobre);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14, left: 4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.perfil);
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: const Color(0xFF262626),
                    child: Text(
                      _authCtrl.nomeExibicao.isNotEmpty
                          ? _authCtrl.nomeExibicao[0].toUpperCase()
                          : 'O',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              IndexedStack(
                index: _indiceAba,
                children: _telas,
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MiniPlayerWidget(),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF1C1C1C),
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _indiceAba,
              onTap: (index) {
                setState(() {
                  _indiceAba = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_filled),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  activeIcon: Icon(Icons.explore),
                  label: 'Explorar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_outlined),
                  activeIcon: Icon(Icons.library_music),
                  label: 'Biblioteca',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Buscar',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
