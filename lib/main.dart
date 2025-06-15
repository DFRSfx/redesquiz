import 'package:flutter/material.dart';
import 'score_manager.dart';
import 'network_quiz.dart';
import 'database_helper.dart';

/// Função principal da aplicação
/// Inicializa o Flutter binding e a base de dados antes de executar a aplicação
void main() async {
  // Garante que o Flutter binding esteja inicializado antes de operações assíncronas
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a base de dados SQLite
  await initializeDatabase();

  // Executa a aplicação principal
  runApp(const NetworkQuizApp());
}

/// Inicializa a base de dados da aplicação
/// Cria uma instância do DatabaseHelper e inicializa a base de dados
Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database; // Inicializa a base de dados
}

/// Widget principal da aplicação
/// Define o tema, configurações e rotas da aplicação
///
/// Este widget configura:
/// - Tema escuro com cores azuis
/// - Configurações da AppBar
/// - Tema dos Cards com bordas arredondadas
/// - Tema dos botões elevados
/// - Esquema de cores para textos
/// - Rotas de navegação da aplicação
class NetworkQuizApp extends StatelessWidget {
  const NetworkQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz de Redes IPv4',
      debugShowCheckedModeBanner: false,

      // Configuração do tema da aplicação com cores escuras
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(
          0xFF0A0E27,
        ), // Azul escuro para o fundo
        // Tema da AppBar com cor azul mais clara que o fundo
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1F3A), // Azul mais claro que o fundo
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        // Tema dos Cards com elevação e bordas personalizadas
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1F3A),
          elevation: 8,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFF2E3B6F), width: 1),
          ),
        ),

        // Tema dos botões elevados com cor azul clara
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A9EFF), // Azul claro
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Tema dos textos com diferentes tons de branco e azul
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFB8C6DB)), // Azul acinzentado
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(color: Colors.white),
        ),
      ),

      // Ecrã inicial da aplicação
      home: const SplashScreen(),

      // Definição das rotas da aplicação para navegação
      routes: {
        '/home': (context) => const LevelSelectionScreen(),
        '/quiz': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return QuizScreen(level: args['level']);
        },
        '/score': (context) => const ScoreScreen(),
        '/ranking': (context) => const RankingScreen(),
      },
    );
  }
}

/// Ecrã de carregamento inicial (Splash Screen)
/// Exibe o logótipo e nome da aplicação com animação
/// Redireciona automaticamente para o ecrã de nome do utilizador após 3 segundos
///
/// Funcionalidades:
/// - Animação de escala para o conteúdo
/// - Transição suave para o próximo ecrã
/// - Indicador de carregamento visual
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configura a animação de escala para o splash screen
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Aguarda 3 segundos antes de navegar para o próximo ecrã
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UserNameDialog(),
          transitionsBuilder:
              (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone principal da aplicação
              const Icon(Icons.lan, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),

              // Título da aplicação
              Text(
                'IPv4 Network Quiz',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Subtítulo descritivo
              Text(
                'Aprenda endereçamento IP de forma interactiva',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // Indicador de carregamento
              const CircularProgressIndicator(color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Diálogo para captura do nome do utilizador
/// Primeiro ecrã interactivo que o utilizador vê após o splash screen
/// Permite inserir o nome do jogador e navegar para a selecção de níveis
///
/// Características:
/// - Fundo com gradiente linear
/// - Animações de fade e slide
/// - Validação do campo de entrada
/// - Transição suave para o próximo ecrã
class UserNameDialog extends StatefulWidget {
  const UserNameDialog({super.key});

  @override
  _UserNameDialogState createState() => _UserNameDialogState();
}

class _UserNameDialogState extends State<UserNameDialog>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Configura animações de entrada (fade e slide)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fundo com gradiente linear azul
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2E3B6F)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Card(
                    margin: const EdgeInsets.all(32),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ícone decorativo circular
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0x334A9EFF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.router,
                              size: 48,
                              color: Color(0xFF4A9EFF),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Título principal
                          const Text(
                            'Quiz de Redes IPv4',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Descrição da aplicação
                          const Text(
                            'Aprenda endereçamento IPv4 de forma interactiva',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFB8C6DB),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Campo de entrada do nome do utilizador
                          TextField(
                            controller: _usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Nome do jogador',
                              labelStyle: const TextStyle(
                                color: Color(0xFFB8C6DB),
                              ),
                              hintText: 'Digite o seu nome...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF6B7280),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFF4A9EFF),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF2E3B6F),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4A9EFF),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botão para começar o quiz
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Valida se o nome foi preenchido
                                if (_usernameController.text.trim().isEmpty) {
                                  return;
                                }

                                // Armazena o contexto antes da operação assíncrona
                                final currentContext = context;

                                // Guarda o nome do utilizador
                                await ScoreManager.setCurrentUsername(
                                  _usernameController.text.trim(),
                                );

                                // Verifica se o widget ainda está montado
                                if (!mounted) return;

                                // Navega para o ecrã de selecção de níveis
                                Navigator.of(currentContext).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => const LevelSelectionScreen(),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text(
                                'Começar Quiz',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
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
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}

/// Ecrã de selecção de níveis de dificuldade
/// Permite ao utilizador escolher entre 3 níveis diferentes de quiz
/// Também fornece acesso a ferramentas auxiliares e visualização de pontuações
///
/// Funcionalidades:
/// - Três níveis de dificuldade com diferentes pontuações
/// - Animações escalonadas para os cards
/// - Acesso a ferramentas (conversor e verificador)
/// - Navegação para pontuações e ranking
/// - Interface com gradiente e elementos visuais atractivos
class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();

    // Configura animações escalonadas para os cards
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Cria animações com intervalos diferentes para cada card
    _cardAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.2, 1.0, curve: Curves.easeOutBack),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fundo com gradiente linear
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2E3B6F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Cabeçalho com título e botões de navegação
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Ícone da aplicação
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0x334A9EFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.network_check,
                        color: Color(0xFF4A9EFF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Títulos e boas-vindas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quiz de Redes IPv4',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          // Exibe o nome do utilizador actual
                          FutureBuilder<String?>(
                            future: Future.value(
                              ScoreManager.getCurrentUsername(),
                            ),
                            builder: (context, snapshot) {
                              return Text(
                                'Bem-vindo, ${snapshot.data ?? 'Jogador'}!',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFB8C6DB),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Botões de navegação para pontuação e ranking
                    Row(
                      children: [
                        IconButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScoreScreen(),
                                ),
                              ),
                          icon: const Icon(
                            Icons.person,
                            color: Color(0xFF4A9EFF),
                          ),
                          tooltip: 'Minha Pontuação',
                        ),
                        IconButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RankingScreen(),
                                ),
                              ),
                          icon: const Icon(
                            Icons.leaderboard,
                            color: Color(0xFF4A9EFF),
                          ),
                          tooltip: 'Ranking',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Conteúdo principal com cards dos níveis
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Escolha o Nível de Dificuldade',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Lista deslizável com os níveis e ferramentas
                      Expanded(
                        child: ListView(
                          children: [
                            // Nível 1: Básico - Conceitos fundamentais
                            AnimatedBuilder(
                              animation: _cardAnimations[0],
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _cardAnimations[0].value,
                                  child: _buildLevelCard(
                                    context,
                                    level: 1,
                                    title: 'Nível 1: Básico',
                                    subtitle: 'Redes /8, /16 e /24',
                                    description:
                                        'Aprenda os conceitos fundamentais de endereçamento IPv4',
                                    color: const Color(0xFF10B981), // Verde
                                    points: '+10/-5 pontos',
                                    icon: Icons.network_wifi_1_bar,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Nível 2: Sub-redes - Máscaras decimais
                            AnimatedBuilder(
                              animation: _cardAnimations[1],
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _cardAnimations[1].value,
                                  child: _buildLevelCard(
                                    context,
                                    level: 2,
                                    title: 'Nível 2: Sub-redes',
                                    subtitle: 'Máscaras decimais',
                                    description:
                                        'Domine o conceito de sub-redes e máscaras variáveis',
                                    color: const Color(0xFFF59E0B), // Amarelo
                                    points: '+20/-10 pontos',
                                    icon: Icons.network_wifi_2_bar,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Nível 3: Super-redes - Agregação avançada
                            AnimatedBuilder(
                              animation: _cardAnimations[2],
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _cardAnimations[2].value,
                                  child: _buildLevelCard(
                                    context,
                                    level: 3,
                                    title: 'Nível 3: Super-redes',
                                    subtitle: 'Agregação de rotas',
                                    description:
                                        'Desafie-se com super-redes e agregação avançada',
                                    color: const Color(0xFFEF4444), // Vermelho
                                    points: '+30/-15 pontos',
                                    icon: Icons.network_wifi_3_bar,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),

                            // Card com ferramentas auxiliares
                            _buildToolsCard(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói um card para cada nível de dificuldade
  /// Inclui informações sobre pontuação, descrição e navegação para o quiz
  ///
  /// Parâmetros:
  /// - [level]: Número do nível (1, 2 ou 3)
  /// - [title]: Título do nível
  /// - [subtitle]: Subtítulo descritivo
  /// - [description]: Descrição detalhada do nível
  /// - [color]: Cor temática do nível
  /// - [points]: Sistema de pontuação
  /// - [icon]: Ícone representativo
  Widget _buildLevelCard(
    BuildContext context, {
    required int level,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required String points,
    required IconData icon,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        QuizScreen(level: level),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  // Animação de deslize da direita para a esquerda
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Ícone do nível com fundo colorido
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),

              // Informações detalhadas do nível
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB8C6DB),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      points,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Seta indicativa para navegação
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o card de ferramentas auxiliares
  /// Inclui botões para conversor de IP e verificador de rede
  ///
  /// Ferramentas disponíveis:
  /// - Conversor: Para conversão entre formatos de endereçamento
  /// - Verificador: Para verificar se IPs estão na mesma rede
  Widget _buildToolsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho das ferramentas
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0x336366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.build,
                    color: Color(0xFF6366F1),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Ferramentas Auxiliares',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botões das ferramentas em linha
            Row(
              children: [
                // Botão do conversor de IPs
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IpConverterScreen(),
                          ),
                        ),
                    icon: const Icon(Icons.transform, size: 18),
                    label: const Text('Conversor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Botão do verificador de redes
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NetworkCheckScreen(),
                          ),
                        ),
                    icon: const Icon(Icons.compare_arrows, size: 18),
                    label: const Text('Verificador'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Ecrã principal do quiz
/// Gere a lógica do jogo, exibição de perguntas, respostas e pontuação
/// Inclui animações e feedback visual para as respostas
///
/// Funcionalidades principais:
/// - Apresentação sequencial de perguntas
/// - Sistema de pontuação baseado no nível de dificuldade
/// - Feedback visual imediato para respostas
/// - Animações de transição entre perguntas
/// - Barra de progresso visual
/// - Navegação para ecrã de resultados
class QuizScreen extends StatefulWidget {
  final int level; // Nível de dificuldade seleccionado

  const QuizScreen({super.key, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late List<NetworkQuestion> questions; // Lista de perguntas do quiz
  int _currentQuestionIndex = 0; // Índice da pergunta actual
  int _sessionScore = 0; // Pontuação da sessão actual
  int? _selectedOptionIndex; // Índice da opção seleccionada
  bool _answered = false; // Se a pergunta foi respondida
  bool _showNextButton = false; // Se deve mostrar o botão "próximo"
  bool _isCorrect = false; // Se a resposta está correcta

  // Controladores de animação para transições e feedback
  late AnimationController _fadeController;
  late AnimationController _scoreController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    // Configura animações para transições de pergunta e feedback de pontuação
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.elasticOut),
    );

    // Gera as perguntas para o nível seleccionado
    final generator = NetworkQuizGenerator();
    questions =
        generator.generateQuestionsForLevel(widget.level).take(5).toList();
    _fadeController.forward();
  }

  /// Processa a resposta do utilizador
  /// Calcula a pontuação baseada no nível e na correcção da resposta
  ///
  /// Sistema de pontuação:
  /// - Nível 1: +10 pontos (correcto) / -5 pontos (incorrecto)
  /// - Nível 2: +20 pontos (correcto) / -10 pontos (incorrecto)
  /// - Nível 3: +30 pontos (correcto) / -15 pontos (incorrecto)
  void _answerQuestion(int selectedIndex) async {
    if (_answered) return; // Previne múltiplas respostas

    setState(() {
      _selectedOptionIndex = selectedIndex;
      _answered = true;

      // Verificar se a resposta está correcta
      _isCorrect =
          questions[_currentQuestionIndex].options[selectedIndex] ==
          questions[_currentQuestionIndex].correctAnswer;

      // Actualizar pontuação conforme especificação
      if (_isCorrect) {
        switch (widget.level) {
          case 1:
            _sessionScore += 10;
            break;
          case 2:
            _sessionScore += 20;
            break;
          case 3:
            _sessionScore += 30;
            break;
        }
      } else {
        switch (widget.level) {
          case 1:
            _sessionScore -= 5;
            break;
          case 2:
            _sessionScore -= 10;
            break;
          case 3:
            _sessionScore -= 15;
            break;
        }
      }
    });

    // Feedback visual animado para resposta correcta
    if (_isCorrect) {
      await _scoreController.forward();
      await _scoreController.reverse();
    }

    // Aguardar um tempo para o utilizador ver o resultado
    await Future.delayed(const Duration(milliseconds: 800));

    // Mostrar o botão (tanto para correcto quanto incorrecto)
    if (mounted) {
      setState(() {
        _showNextButton = true;
      });
    }
  }

  /// Avança para a próxima pergunta ou finaliza o quiz
  /// Gere as transições entre perguntas e navegação final
  void _nextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      _fadeController.reset();
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _answered = false;
        _showNextButton = false;
      });
      _fadeController.forward();
    } else {
      _finishQuiz();
    }
  }

  /// Finaliza o quiz e navega para o ecrã de resultados
  /// Guarda a pontuação da sessão na base de dados
  void _finishQuiz() async {
    // Armazenar contexto antes da operação assíncrona
    final currentContext = context;

    await ScoreManager.addToCurrentUserScore(_sessionScore);

    if (!mounted) return;

    Navigator.of(currentContext).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => QuizResultScreen(
              level: widget.level,
              sessionScore: _sessionScore,
              totalQuestions: questions.length,
              correctAnswers: _getCorrectAnswersCount(),
            ),
      ),
    );
  }

  /// Calcula o número de respostas correctas baseado na pontuação
  /// Utiliza a pontuação por nível para estimar acertos
  int _getCorrectAnswersCount() {
    return _sessionScore > 0 ? (_sessionScore / (widget.level * 10)).ceil() : 0;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2E3B6F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Cabeçalho com informações da sessão
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Botão de voltar
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        // Informações de progresso
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Nível ${widget.level} - Questão ${_currentQuestionIndex + 1}/${questions.length}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Barra de progresso visual
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: const Color(0xFF2E3B6F),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4A9EFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Indicador de pontuação actual
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _sessionScore >= 0
                                    ? Color(0x3310B981)
                                    : Color(0x33EF4444),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AnimatedBuilder(
                            animation: _scoreAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_scoreAnimation.value * 0.2),
                                child: Text(
                                  '${_sessionScore >= 0 ? '+' : ''}$_sessionScore',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _sessionScore >= 0
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFEF4444),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Área principal da pergunta e opções
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Etiqueta do tipo de pergunta
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0x334A9EFF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                question.type,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A9EFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Texto da pergunta
                            Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Lista de opções de resposta
                            Expanded(
                              child: ListView.builder(
                                itemCount: question.options.length,
                                itemBuilder: (context, index) {
                                  final option = question.options[index];
                                  final isCorrect =
                                      option == question.correctAnswer;
                                  final isSelected =
                                      index == _selectedOptionIndex;

                                  // Determinar cores baseadas no estado
                                  Color? buttonColor;
                                  Color textColor =
                                      Colors.white; // Cor padrão do texto
                                  if (_answered) {
                                    if (isCorrect) {
                                      buttonColor = const Color(0xFF10B981);
                                      textColor = Colors.white;
                                    } else if (isSelected) {
                                      buttonColor = const Color(0xFFEF4444);
                                      textColor = Colors.white;
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            _answered
                                                ? null
                                                : () => _answerQuestion(index),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              buttonColor ??
                                              const Color(0xFF2E3B6F),
                                          foregroundColor:
                                              textColor, // Usar a cor definida
                                          padding: const EdgeInsets.all(16),
                                          side: BorderSide(
                                            color:
                                                buttonColor ??
                                                const Color(0xFF4A9EFF),
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Indicador alfabético da opção
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    buttonColor?.withAlpha(
                                                      77, // 255 * 0.3 ≈ 77
                                                    ) ??
                                                    const Color(0x334A9EFF),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  String.fromCharCode(
                                                    65 + index,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        textColor, // Usar a cor definida
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            // Texto da opção
                                            Expanded(
                                              child: Text(
                                                option,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      textColor, // Usar a cor definida
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Botão para avançar (aparece após responder)
              if (_showNextButton)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AnimatedOpacity(
                    opacity: _showNextButton ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton.icon(
                      onPressed: _nextQuestion,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        _currentQuestionIndex < questions.length - 1
                            ? 'Próxima Pergunta'
                            : 'Ver Resultados',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A9EFF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scoreController.dispose();
    super.dispose();
  }
}

/// Ecrã de resultados do quiz
/// Apresenta o desempenho do utilizador após completar um quiz
/// Mostra estatísticas detalhadas e opções de navegação
///
/// Funcionalidades:
/// - Exibição de pontuação final
/// - Contagem de respostas correctas
/// - Feedback visual baseado no desempenho
/// - Opções para repetir ou voltar ao menu principal
class QuizResultScreen extends StatelessWidget {
  final int level; // Nível de dificuldade concluído
  final int sessionScore; // Pontuação obtida na sessão
  final int totalQuestions; // Número total de perguntas
  final int correctAnswers; // Número de respostas correctas

  const QuizResultScreen({
    super.key,
    required this.level,
    required this.sessionScore,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final isPass = sessionScore > 0; // Determina se o utilizador passou
    final color = isPass ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2E3B6F)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícone de resultado (sucesso ou erro)
                      Icon(
                        isPass ? Icons.check_circle : Icons.error,
                        size: 80,
                        color: color,
                      ),
                      const SizedBox(height: 24),

                      // Mensagem de resultado
                      Text(
                        isPass ? 'Parabéns!' : 'Tente Novamente',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Indicação do nível concluído
                      Text(
                        'Nível $level Concluído',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Estatísticas de respostas correctas
                      Text(
                        '$correctAnswers/$totalQuestions correctas',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Pontuação final destacada
                      Text(
                        'Pontuação: ${sessionScore >= 0 ? '+' : ''}$sessionScore',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botões de acção
                      Row(
                        children: [
                          // Botão para voltar ao menu principal
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                              ),
                              child: const Text('Menu Principal'),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Botão para tentar novamente
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => QuizScreen(level: level),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                              ),
                              child: const Text('Tentar Novamente'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ecrã de visualização da pontuação pessoal
/// Apresenta a pontuação actual do utilizador logado
/// Permite definir nome se ainda não foi configurado
///
/// Funcionalidades:
/// - Exibição da pontuação total acumulada
/// - Nome do jogador actual
/// - Opção para redefinir nome do utilizador
class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Pontuação')),
      body: FutureBuilder<int>(
        future: ScoreManager.getCurrentUserScore(),
        builder: (context, scoreSnapshot) {
          final username = ScoreManager.getCurrentUsername();

          // Indicador de carregamento
          if (scoreSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final score = scoreSnapshot.data ?? 0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nome do jogador
                Text(
                  'Jogador: ${username ?? 'N/A'}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),

                // Pontuação actual destacada
                Text(
                  'Pontuação Actual: $score',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Botão para definir nome se necessário
                if (username == null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserNameDialog(),
                        ),
                      );
                    },
                    child: const Text('Definir Nome de Utilizador'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Ecrã do ranking global
/// Apresenta os 5 melhores jogadores por pontuação
/// Utiliza cores especiais para os primeiros 3 lugares
///
/// Sistema de classificação:
/// - 1º lugar: Dourado
/// - 2º lugar: Prateado
/// - 3º lugar: Bronze
/// - 4º-5º lugar: Branco padrão
class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 5 Jogadores')),
      body: FutureBuilder(
        future: ScoreManager.getTopScores(),
        builder: (context, snapshot) {
          // Indicador de carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final topScores = snapshot.data ?? [];

          // Mensagem quando não há dados
          if (topScores.isEmpty) {
            return const Center(
              child: Text('Nenhuma pontuação registada ainda.'),
            );
          }

          return ListView.builder(
            itemCount: topScores.length,
            itemBuilder: (context, index) {
              final entry = topScores[index];

              // Define cores personalizadas para o top 3
              Color rankColor;
              if (index == 0) {
                rankColor = Colors.amber; // Dourado
              } else if (index == 1) {
                rankColor = Colors.grey; // Prateado
              } else if (index == 2) {
                rankColor = Color(
                  0xFFCD7F32,
                ); // Bronze (cor hexadecimal personalizada)
              } else {
                rankColor = Colors.white; // Padrão
              }

              return ListTile(
                // Posição no ranking
                leading: Text(
                  '${index + 1}º',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                  ),
                ),
                // Nome do utilizador
                title: Text(
                  entry['username'] ?? 'Desconhecido',
                  style: const TextStyle(color: Colors.white),
                ),
                // Pontuação do utilizador
                trailing: Text(
                  entry['score'].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Ecrã do conversor avançado de rede
/// Ferramenta para conversão e cálculo de endereçamento IPv4
/// Suporta tanto prefixos CIDR quanto máscaras decimais
///
/// Funcionalidades principais:
/// - Cálculo de Network ID
/// - Cálculo de endereço Broadcast
/// - Suporte para prefixos CIDR (/24) e máscaras (255.255.255.0)
/// - Validação de entrada robusta
/// - Interface intuitiva com alternância entre modos
class IpConverterScreen extends StatefulWidget {
  const IpConverterScreen({super.key});

  @override
  _IpConverterScreenState createState() => _IpConverterScreenState();
}

class _IpConverterScreenState extends State<IpConverterScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _maskOrPrefixController = TextEditingController();
  String _result = '';
  bool _usePrefix = true; // Determina se usa prefixo CIDR ou máscara decimal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversor Avançado de Rede')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo para endereço IP
              TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'Endereço IP (ex: 192.168.1.10)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Alternador entre prefixo e máscara
              Row(
                children: [
                  const Text('Usar Prefixo:'),
                  Switch(
                    value: _usePrefix,
                    onChanged: (value) {
                      setState(() {
                        _usePrefix = value;
                        _maskOrPrefixController.clear();
                        _result = '';
                      });
                    },
                  ),
                ],
              ),

              // Campo dinâmico (prefixo CIDR ou máscara decimal)
              TextField(
                controller: _maskOrPrefixController,
                decoration: InputDecoration(
                  labelText:
                      _usePrefix
                          ? 'Comprimento do Prefixo (ex: 24)'
                          : 'Máscara de Sub-rede (ex: 255.255.255.0)',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Botões de acção para cálculos
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: _calculateNetworkId,
                    child: const Text('Calcular Network ID'),
                  ),
                  ElevatedButton(
                    onPressed: _calculateBroadcast,
                    child: const Text('Calcular Broadcast'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Área de resultados com formatação condicional
              if (_result.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        _result.startsWith('Erro:')
                            ? Colors.red.withAlpha(26) // 255 * 0.1 ≈ 26
                            : Colors.green.withAlpha(26), // 255 * 0.1 ≈ 26
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _result.startsWith('Erro:')
                              ? Colors.red
                              : Colors.green,
                    ),
                  ),
                  child: Text(
                    _result,
                    style: TextStyle(
                      color:
                          _result.startsWith('Erro:')
                              ? Colors.red
                              : Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calcula o Network ID baseado no IP e máscara/prefixo fornecidos
  /// Valida as entradas e apresenta o resultado formatado
  void _calculateNetworkId() {
    if (_ipController.text.isEmpty || _maskOrPrefixController.text.isEmpty) {
      setState(() {
        _result = 'Erro: Preencha todos os campos';
      });
      return;
    }

    if (!_isValidIp(_ipController.text)) {
      setState(() {
        _result = 'Erro: Endereço IP inválido';
      });
      return;
    }

    try {
      final prefixLength = _getPrefixLength();
      final networkId = getNetworkId(_ipController.text, prefixLength);

      setState(() {
        _result = 'Network ID: $networkId/$prefixLength';
      });
    } catch (e) {
      setState(() {
        _result = 'Erro: ${e.toString().replaceAll('FormatException: ', '')}';
      });
    }
  }

  /// Calcula o endereço de broadcast baseado no IP e máscara/prefixo
  /// Utiliza as mesmas validações do Network ID
  void _calculateBroadcast() {
    if (_ipController.text.isEmpty || _maskOrPrefixController.text.isEmpty) {
      setState(() {
        _result = 'Erro: Preencha todos os campos';
      });
      return;
    }

    if (!_isValidIp(_ipController.text)) {
      setState(() {
        _result = 'Erro: Endereço IP inválido';
      });
      return;
    }

    try {
      final prefixLength = _getPrefixLength();
      final broadcast = getBroadcastAddress(_ipController.text, prefixLength);

      setState(() {
        _result = 'Endereço Broadcast: $broadcast';
      });
    } catch (e) {
      setState(() {
        _result = 'Erro: ${e.toString().replaceAll('FormatException: ', '')}';
      });
    }
  }

  /// Obtém o comprimento do prefixo baseado no modo seleccionado
  /// Converte máscara decimal para prefixo CIDR se necessário
  ///
  /// Returns: Comprimento do prefixo (0-32)
  /// Throws: FormatException se a entrada for inválida
  int _getPrefixLength() {
    if (_usePrefix) {
      final prefix = int.parse(_maskOrPrefixController.text);
      if (prefix < 0 || prefix > 32) {
        throw const FormatException('Prefixo inválido (0-32)');
      }
      return prefix;
    } else {
      if (!_isValidSubnetMask(_maskOrPrefixController.text)) {
        throw const FormatException('Máscara de sub-rede inválida');
      }
      return maskToPrefixLength(_maskOrPrefixController.text);
    }
  }

  /// Valida se uma string representa um endereço IP válido
  /// Verifica formato (4 octetos) e intervalo (0-255 por octeto)
  ///
  /// [ip]: String a ser validada como endereço IP
  /// Returns: true se válido, false caso contrário
  bool _isValidIp(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;

    try {
      for (final part in parts) {
        final num = int.parse(part);
        if (num < 0 || num > 255) return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Valida se uma string representa uma máscara de sub-rede válida
  /// Verifica se é um IP válido e se os bits estão em sequência correcta
  ///
  /// [mask]: String a ser validada como máscara
  /// Returns: true se válida, false caso contrário
  bool _isValidSubnetMask(String mask) {
    if (!_isValidIp(mask)) return false;

    final maskInt = ipToInt(mask);
    var foundZero = false;
    // Verifica se os bits 1 estão todos à esquerda (sem intercalação)
    for (var i = 31; i >= 0; i--) {
      final bit = (maskInt >> i) & 1;
      if (foundZero && bit == 1) return false;
      if (bit == 0) foundZero = true;
    }
    return true;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _maskOrPrefixController.dispose();
    super.dispose();
  }
}

/// Ecrã de verificação de rede
/// Ferramenta para verificar se dois endereços IP pertencem à mesma rede
/// Suporta tanto prefixos CIDR quanto máscaras decimais
///
/// Funcionalidades principais:
/// - Comparação de dois endereços IP
/// - Determinação se estão na mesma rede ou sub-rede
/// - Exibição das redes de cada IP quando diferentes
/// - Suporte para prefixos CIDR e máscaras decimais
/// - Feedback visual claro com ícones e cores
class NetworkCheckScreen extends StatefulWidget {
  const NetworkCheckScreen({super.key});

  @override
  _NetworkCheckScreenState createState() => _NetworkCheckScreenState();
}

class _NetworkCheckScreenState extends State<NetworkCheckScreen> {
  final TextEditingController _ip1Controller = TextEditingController();
  final TextEditingController _ip2Controller = TextEditingController();
  final TextEditingController _maskOrPrefixController = TextEditingController();
  String _checkResult = '';
  bool _usePrefix = true; // Determina se usa prefixo CIDR ou máscara decimal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar Rede')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo para o primeiro endereço IP
              TextField(
                controller: _ip1Controller,
                decoration: const InputDecoration(
                  labelText: 'Primeiro IP (ex: 192.168.1.10)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Campo para o segundo endereço IP
              TextField(
                controller: _ip2Controller,
                decoration: const InputDecoration(
                  labelText: 'Segundo IP (ex: 192.168.1.20)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Alternador entre prefixo CIDR e máscara decimal
              Row(
                children: [
                  const Text('Usar Prefixo:'),
                  Switch(
                    value: _usePrefix,
                    onChanged: (value) {
                      setState(() {
                        _usePrefix = value;
                        _maskOrPrefixController.clear();
                        _checkResult = '';
                      });
                    },
                  ),
                ],
              ),

              // Campo dinâmico para prefixo ou máscara
              TextField(
                controller: _maskOrPrefixController,
                decoration: InputDecoration(
                  labelText:
                      _usePrefix
                          ? 'Comprimento do Prefixo (ex: 24)'
                          : 'Máscara de Sub-rede (ex: 255.255.255.0)',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Botão principal de verificação
              ElevatedButton(
                onPressed: _checkNetwork,
                child: const Text('Verificar Rede'),
              ),
              const SizedBox(height: 24),

              // Área de resultados com formatação condicional
              if (_checkResult.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        _checkResult.startsWith('✅')
                            ? Colors.green.withAlpha(26) // 255 * 0.1 ≈ 26
                            : Colors.red.withAlpha(26), // 255 * 0.1 ≈ 26
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _checkResult.startsWith('✅')
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  child: Text(
                    _checkResult,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _checkResult.startsWith('✅')
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Verifica se os dois IPs fornecidos pertencem à mesma rede
  /// Calcula o Network ID de ambos e compara os resultados
  /// Apresenta feedback detalhado sobre o resultado da comparação
  void _checkNetwork() {
    // Validação de campos obrigatórios
    if (_ip1Controller.text.isEmpty ||
        _ip2Controller.text.isEmpty ||
        _maskOrPrefixController.text.isEmpty) {
      setState(() {
        _checkResult = 'Erro: Preencha todos os campos';
      });
      return;
    }

    try {
      final prefixLength = _getPrefixLength();

      // Verifica se os IPs estão na mesma rede
      final sameNetwork = areInSameNetwork(
        _ip1Controller.text,
        _ip2Controller.text,
        prefixLength,
      );

      // Calcula os Network IDs para apresentação detalhada
      final network1 = getNetworkId(_ip1Controller.text, prefixLength);
      final network2 = getNetworkId(_ip2Controller.text, prefixLength);

      setState(() {
        _checkResult =
            sameNetwork
                ? '✅ Os IPs estão na MESMA rede ($network1/$prefixLength)'
                : '❌ Os IPs estão em REDES DIFERENTES\n\n'
                    'IP ${_ip1Controller.text} está em $network1/$prefixLength\n'
                    'IP ${_ip2Controller.text} está em $network2/$prefixLength';
      });
    } catch (e) {
      setState(() {
        _checkResult = 'Erro: ${e.toString()}';
      });
    }
  }

  /// Obtém o comprimento do prefixo baseado no modo seleccionado
  /// Idêntico ao método da classe IpConverterScreen
  ///
  /// Returns: Comprimento do prefixo (0-32)
  /// Throws: Exception se a entrada for inválida
  int _getPrefixLength() {
    if (_usePrefix) {
      final prefix = int.parse(_maskOrPrefixController.text);
      if (prefix < 0 || prefix > 32) throw Exception('Prefixo inválido (0-32)');
      return prefix;
    } else {
      return maskToPrefixLength(_maskOrPrefixController.text);
    }
  }

  @override
  void dispose() {
    _ip1Controller.dispose();
    _ip2Controller.dispose();
    _maskOrPrefixController.dispose();
    super.dispose();
  }
}
