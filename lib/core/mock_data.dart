import 'package:flutter/material.dart';
import '../model/album_model.dart';
import '../model/playlist_model.dart';
import '../model/song_model.dart';

class MockData {
  static final List<SongModel> musicas = [
    SongModel(
      id: '1',
      titulo: 'Nocturne Op. 9 No. 2 em Mi Bemol Maior',
      artista: 'Frédéric Chopin',
      album: 'Chopin: Nocturnes & Preludes',
      duracao: const Duration(minutes: 4, seconds: 32),
      gradienteCapa: [const Color(0xFF1B2A4A), const Color(0xFF384E77)],
      icone: Icons.piano,
      genero: 'Piano Solo',
      isCurtida: true,
      letra: "Andante em Mi Bemol Maior (12/8)\n"
          "Composto entre 1830 e 1832 • Op. 9 No. 2\n"
          "Dedicado a Madame Marie Moke Pleyel\n\n"
          "Uma das obras mais líricas e contemplativas da história da música ocidental.\n"
          "A melodia flutua sobre um acompanhamento em arpejo suave da mão esquerda,\n"
          "desenvolvendo-se com ornamentações expressivas em fioritura e culminando\n"
          "numa cadência apaixonada com diminuendo pianíssimo no encerramento.",
    ),
    SongModel(
      id: '2',
      titulo: 'Valsa do Minuto (Op. 64 No. 1)',
      artista: 'Frédéric Chopin',
      album: 'Chopin: Nocturnes & Preludes',
      duracao: const Duration(minutes: 1, seconds: 54),
      gradienteCapa: [const Color(0xFF4A1525), const Color(0xFF7A203A)],
      icone: Icons.piano,
      genero: 'Piano Solo',
      isCurtida: true,
      letra: "Molto vivace em Ré Bemol Maior (3/4)\n"
          "Composta em 1847 • Op. 64 No. 1\n"
          "Dedicada à Condessa Delfina Potocka\n\n"
          "A célebre 'Valse du petit chien', inspirada segundo a lenda no cachorro\n"
          "de George Sand correndo atrás da própria cauda.\n"
          "Uma demonstração de virtuosismo e leveza onde as notas giram em velocidade\n"
          "reluzente, pontuada por um trio central de lirismo aristocrático.",
    ),
    SongModel(
      id: '3',
      titulo: 'Prelúdio Op. 28 No. 4 em Mi Menor',
      artista: 'Frédéric Chopin',
      album: 'Chopin: Nocturnes & Preludes',
      duracao: const Duration(minutes: 2, seconds: 20),
      gradienteCapa: [const Color(0xFF2C1938), const Color(0xFF5A2A66)],
      icone: Icons.piano,
      genero: 'Romântico',
      isCurtida: false,
      letra: "Largo em Mi Menor (C)\n"
          "Composto em Valldemossa, Maiorca (1838–1839)\n\n"
          "Descrito por Hans von Bülow como 'uma sufocação da alma'.\n"
          "A mão direita sustenta uma melodia de quase imobilidade meditativa,\n"
          "enquanto a mão esquerda desce através de harmonias cromáticas sombrias\n"
          "de dor e desolação. Executada no próprio funeral de Chopin em Paris.",
    ),

    SongModel(
      id: '4',
      titulo: 'Ária na Corda Sol (Suite Orquestral No. 3)',
      artista: 'Johann Sebastian Bach',
      album: 'Bach: Concertos & Suites',
      duracao: const Duration(minutes: 5, seconds: 12),
      gradienteCapa: [const Color(0xFF1E3A2F), const Color(0xFF2E5A44)],
      icone: Icons.music_note,
      genero: 'Barroco',
      isCurtida: true,
      letra: "Air da Suíte para Orquestra No. 3 em Ré Maior (BWV 1068)\n"
          "Composta por volta de 1730 em Leipzig\n\n"
          "A linha melódica mais sublime e atemporal do gênio barroco.\n"
          "A linha de baixo descende em passos solenes enquanto os primeiros\n"
          "violinos tecem uma oração contínua de serenidade e infinita paz.\n"
          "Famosa pelo arranjo para violino na corda Sol por August Wilhelmj.",
    ),
    SongModel(
      id: '5',
      titulo: 'Concertos de Brandemburgo No. 3 (Allegro)',
      artista: 'Johann Sebastian Bach',
      album: 'Bach: Concertos & Suites',
      duracao: const Duration(minutes: 5, seconds: 48),
      gradienteCapa: [const Color(0xFF3D2C1D), const Color(0xFF6B4E32)],
      icone: Icons.album,
      genero: 'Barroco',
      isCurtida: false,
      letra: "Concerto de Brandemburgo No. 3 em Sol Maior (BWV 1048)\n"
          "I. Allegro moderato • Composto em Köthen (1721)\n"
          "Dedicado a Christian Ludwig, Margrave de Brandemburgo\n\n"
          "Uma arquitetura contrapontística genial escrita para nove solistas:\n"
          "três violinos, três violas, três violoncelos e baixo contínuo.\n"
          "Energia contagiante, rigor matemático e júbilo sonoro inigualável.",
    ),
    SongModel(
      id: '6',
      titulo: 'O Cravo Bem Temperado: Prelúdio No. 1',
      artista: 'Johann Sebastian Bach',
      album: 'Bach: O Cravo Bem Temperado',
      duracao: const Duration(minutes: 2, seconds: 15),
      gradienteCapa: [const Color(0xFF1F2937), const Color(0xFF374151)],
      icone: Icons.auto_stories,
      genero: 'Barroco',
      isCurtida: true,
      letra: "Prelúdio No. 1 em Dó Maior (BWV 846)\n"
          "Das Wohltemperierte Klavier, Livro I (1722)\n\n"
          "Uma progressão de arpejos simples e divinos que estabeleceu\n"
          "as bases de toda a afinação moderna e da harmonia tonal.\n"
          "Mais tarde serviu de base harmônica para a clássica 'Ave Maria' de Gounod.",
    ),

    SongModel(
      id: '7',
      titulo: 'Messiah: Hallelujah Chorus',
      artista: 'George Frideric Händel',
      album: 'Händel: Messiah & Water Music',
      duracao: const Duration(minutes: 4, seconds: 18),
      gradienteCapa: [const Color(0xFF5B1E1E), const Color(0xFF8B2E2E)],
      icone: Icons.church,
      genero: 'Coral & Ópera',
      isCurtida: true,
      letra: "Hallelujah! Hallelujah! Hallelujah! Hallelujah! Hallelujah!\n"
          "For the Lord God Omnipotent reigneth!\n"
          "Hallelujah! Hallelujah! Hallelujah! Hallelujah!\n\n"
          "The kingdom of this world\n"
          "Is become the kingdom of our Lord,\n"
          "And of His Christ;\n"
          "And He shall reign for ever and ever!\n\n"
          "King of Kings, and Lord of Lords,\n"
          "King of Kings, and Lord of Lords,\n"
          "And He shall reign for ever and ever!\n"
          "Hallelujah! Hallelujah! Hallelujah!",
    ),
    SongModel(
      id: '8',
      titulo: 'Música Aquática: Alla Hornpipe',
      artista: 'George Frideric Händel',
      album: 'Händel: Messiah & Water Music',
      duracao: const Duration(minutes: 3, seconds: 14),
      gradienteCapa: [const Color(0xFF14304A), const Color(0xFF1E527F)],
      icone: Icons.sailing,
      genero: 'Orquestral',
      isCurtida: false,
      letra: "Water Music, Suite No. 2 em Ré Maior (HWV 349)\n"
          "II. Alla Hornpipe • Composta em 1717\n"
          "Composta para o rei George I da Grã-Bretanha\n\n"
          "Apresentada ao vivo enquanto a corte real navegava em barcaças\n"
          "pelo Rio Tâmisa de Whitehall a Chelsea. O rei ficou tão encantado\n"
          "que exigiu que a orquestra repetisse a obra três vezes inteiras.",
    ),
    SongModel(
      id: '9',
      titulo: 'Zadok the Priest',
      artista: 'George Frideric Händel',
      album: 'Händel: Coronation Anthems',
      duracao: const Duration(minutes: 5, seconds: 38),
      gradienteCapa: [const Color(0xFF4A3810), const Color(0xFF7A5C1E)],
      icone: Icons.workspace_premium_rounded,
      genero: 'Orquestral',
      isCurtida: true,
      letra: "Coronation Anthem No. 1 (HWV 258)\n"
          "Composta para a coroação de George II em 1727 na Abadia de Westminster\n\n"
          "Zadok the priest and Nathan the prophet\n"
          "Anointed Solomon king.\n"
          "And all the people rejoic'd, and said:\n"
          "God save the king! Long live the king!\n"
          "May the king live for ever,\n"
          "Amen, Alleluia, Amen, Alleluia, Amen!",
    ),
  ];

  static final List<AlbumModel> albuns = [
    AlbumModel(
      id: 'alb_1',
      titulo: 'Chopin: Nocturnes & Preludes',
      artista: 'Frédéric Chopin',
      ano: 1832,
      gradienteCapa: [const Color(0xFF1B2A4A), const Color(0xFF384E77)],
      icone: Icons.piano,
      descricao: 'A essência da alma romântica em composições para piano solo de lirismo comovente e virtuosismo poético.',
      faixas: [musicas[0], musicas[1], musicas[2]],
    ),
    AlbumModel(
      id: 'alb_2',
      titulo: 'Bach: Concertos & Suites',
      artista: 'Johann Sebastian Bach',
      ano: 1721,
      gradienteCapa: [const Color(0xFF1E3A2F), const Color(0xFF2E5A44)],
      icone: Icons.music_note,
      descricao: 'Obras-primas monumentais da era barroca unindo rigor contrapontístico, beleza matemática e espiritualidade.',
      faixas: [musicas[3], musicas[4], musicas[5]],
    ),
    AlbumModel(
      id: 'alb_3',
      titulo: 'Händel: Messiah & Water Music',
      artista: 'George Frideric Händel',
      ano: 1741,
      gradienteCapa: [const Color(0xFF5B1E1E), const Color(0xFF8B2E2E)],
      icone: Icons.church,
      descricao: 'Grandiosidade coral e suntuosidade orquestral que marcaram a corte britânica e a história da música sacra.',
      faixas: [musicas[6], musicas[7], musicas[8]],
    ),
    AlbumModel(
      id: 'alb_4',
      titulo: 'Bach: O Cravo Bem Temperado',
      artista: 'Johann Sebastian Bach',
      ano: 1722,
      gradienteCapa: [const Color(0xFF1F2937), const Color(0xFF374151)],
      icone: Icons.auto_stories,
      descricao: 'A bíblia do teclado barroco percorrendo todas as tonalidades maiores e menores em prelúdios e fugas inesquecíveis.',
      faixas: [musicas[5]],
    ),
  ];

  static final List<PlaylistModel> playlists = [
    PlaylistModel(
      id: 'pl_1',
      titulo: 'Foco & Concentração com Bach',
      descricao: 'Clareza mental, matemática polifônica e harmonia pura para estudar e produzir.',
      gradienteCapa: [const Color(0xFF1E3A2F), const Color(0xFF2E5A44)],
      icone: Icons.psychology_rounded,
      faixas: [musicas[3], musicas[4], musicas[5]],
    ),
    PlaylistModel(
      id: 'pl_2',
      titulo: 'Poesia Noturna ao Piano: Chopin',
      descricao: 'Nocturnes, valsas e prelúdios para acalmar a mente ao fim da noite.',
      gradienteCapa: [const Color(0xFF1B2A4A), const Color(0xFF384E77)],
      icone: Icons.nightlight_round,
      faixas: [musicas[0], musicas[1], musicas[2]],
    ),
    PlaylistModel(
      id: 'pl_3',
      titulo: 'Majestade Barroca: Händel',
      descricao: 'Corais solenes, trompetes triunfais e fanfarras da orquestra barroca.',
      gradienteCapa: [const Color(0xFF5B1E1E), const Color(0xFF8B2E2E)],
      icone: Icons.castle_rounded,
      faixas: [musicas[6], musicas[7], musicas[8]],
    ),
  ];

  static final List<String> generos = [
    'Todos',
    'Barroco',
    'Romântico',
    'Piano Solo',
    'Orquestral',
    'Coral & Ópera',
  ];
}
