# Fourier Music Player

Reprodutor musical multiplataforma desenvolvido em Flutter e Dart, com interface inspirada no YouTube Music. O projeto utiliza tema escuro, navegação simplificada e recursos de organização e reprodução musical.

## Informações do projeto

- **Desenvolvedor:** Otávio
- **Versão:** 1.0.0 (Build 1)

## Funcionalidades

### Autenticação e perfil

- **Login:** validação de e-mail e senha, mensagens de erro e navegação para cadastro e recuperação de senha.
- **Cadastro:** formulário com nome, e-mail, telefone, senha e confirmação de senha.
- **Recuperação de senha:** validação do e-mail e simulação do envio das instruções de recuperação.
- **Perfil:** edição de nome e telefone, visualização do e-mail e encerramento de sessão.
- **Sobre:** informações sobre o projeto, os integrantes, a instituição, a disciplina e a versão.

### Reprodutor musical

- **Início:** saudação personalizada, filtros por atividade, álbuns em destaque, músicas reproduzidas recentemente e faixas populares.
- **Explorar:** navegação por gêneros musicais, com filtros para Pop, Rock, Eletrônica, Hip Hop, MPB e Lo-Fi.
- **Biblioteca:** gerenciamento de playlists, músicas curtidas e histórico de reprodução.
- **Player:** controles de reprodução, avanço e retrocesso na faixa, reprodução aleatória, repetição e barra de progresso interativa.
- **Letras e fila:** visualização de letras e gerenciamento da fila de reprodução.
- **Pesquisa:** busca em tempo real com filtros por músicas, artistas e álbuns.
- **Detalhes de álbuns e playlists:** exibição de metadados, listagem de faixas e opções de reprodução.
- **Mini player:** controles persistentes na interface, com acesso rápido ao player completo.

As telas utilizam componentes como `ListView`, `GridView` e `ListView.builder`, com dados simulados para demonstrar as funcionalidades.

## Arquitetura

O projeto está organizado em camadas, separando a interface, a lógica de negócio, os modelos e os recursos compartilhados.

```text
lib/
├── controller/
│   ├── auth_controller.dart
│   ├── explore_controller.dart
│   ├── library_controller.dart
│   └── player_controller.dart
├── core/
│   ├── app_routes.dart
│   ├── app_theme.dart
│   ├── mock_data.dart
│   └── service_locator.dart
├── model/
│   ├── album_model.dart
│   ├── playlist_model.dart
│   ├── song_model.dart
│   └── user_model.dart
├── view/
│   ├── widgets/
│   │   ├── album_card_widget.dart
│   │   ├── mini_player_widget.dart
│   │   └── song_tile_widget.dart
│   ├── album_detalhes_view.dart
│   ├── biblioteca_view.dart
│   ├── busca_view.dart
│   ├── cadastrar_view.dart
│   ├── esqueceu_senha_view.dart
│   ├── explorar_view.dart
│   ├── home_view.dart
│   ├── login_view.dart
│   ├── perfil_view.dart
│   ├── player_view.dart
│   ├── principal_view.dart
│   └── sobre_view.dart
└── main.dart
```

### Principais componentes

- **Controllers:** gerenciam autenticação, perfil, pesquisa, biblioteca e reprodução.
- **Models:** representam usuários, músicas, álbuns e playlists.
- **Core:** centraliza rotas, tema, dados de demonstração e injeção de dependências.
- **Views:** contêm as telas e os componentes da interface.

## Como executar

**1. Clonar o repositório**

```bash
git clone https://github.com/<seu-usuario>/flutter_navigator.git
cd flutter_navigator
```

**2. Instalar as dependências**

```bash
flutter pub get
```

**3. Executar a análise e os testes**

```bash
flutter analyze
flutter test
```

**4. Iniciar o aplicativo**

```bash
# Web
flutter run -d chrome

# Windows
flutter run -d windows

# Android ou iOS
flutter run
```
