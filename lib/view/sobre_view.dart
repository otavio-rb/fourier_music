import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações da Build'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF334B),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text(
                          'ω',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Fourier',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Reprodutor de Áudio Pessoal & Autoral',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2C2C2C)),
                      ),
                      child: const Text(
                        'v1.0.0 (Build 1)',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFFAAAAAA),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  _buildSectionCard(
                    context,
                    icone: Icons.explore_outlined,
                    titulo: 'Propósito do Projeto',
                    filhos: [
                      _buildParagraph(
                        'O Fourier nasceu da vontade de construir uma alternativa própria, '
                        'limpa e independente para escutar as músicas que realmente importam, '
                        'sem precisar depender de assinaturas de streaming como o Spotify. '
                        'Embora tais plataformas tenham planos acessíveis, o verdadeiro valor '
                        'está na liberdade de criar o próprio reprodutor: feito sob medida, '
                        'livre de anúncios, sem algoritmos forçando conteúdos comerciais e com '
                        'controle absoluto da biblioteca sonora.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSectionCard(
                    context,
                    icone: Icons.tag,
                    titulo: 'Versão',
                    filhos: [
                      _buildInfoRow(Icons.verified_outlined, 'Versão do Aplicativo', '1.0.0+1'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.tune, 'Canal de Lançamento', 'Build 1 (Stable)'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSectionCard(
                    context,
                    icone: Icons.person_outline_rounded,
                    titulo: 'Desenvolvedor',
                    filhos: [
                      _buildInfoRow(
                        Icons.person,
                        'Desenvolvedor',
                        'Otávio',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: Text(
                      'Fourier • Desenvolvido por Otávio',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    List<Widget>? filhos,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF222222),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, color: const Color(0xFFFF334B), size: 20),
              const SizedBox(width: 10),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...?filhos,
        ],
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13.5,
        height: 1.55,
        color: Color(0xFFCCCCCC),
      ),
    );
  }

  Widget _buildInfoRow(IconData icone, String label, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 16, color: const Color(0xFFAAAAAA)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFAAAAAA),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
