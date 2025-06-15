// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'score_manager.dart';
import 'network_quiz.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const NetworkQuizApp());
}

Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database; // Inicializa o banco de dados
}

class NetworkQuizApp extends StatelessWidget {
  const NetworkQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz de Redes IPv4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1F3A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1F3A),
          elevation: 8,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFF2E3B6F), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A9EFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFB8C6DB)),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
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
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

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
              const Icon(Icons.lan, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                'IPv4 Network Quiz',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Aprenda endereçamento IP de forma interativa',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 30),
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
                          const Text(
                            'Quiz de Redes IPv4',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Aprenda endereçamento IPv4 de forma interativa',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFB8C6DB),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Nome do jogador',
                              labelStyle: const TextStyle(
                                color: Color(0xFFB8C6DB),
                              ),
                              hintText: 'Digite seu nome...',
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_usernameController.text.trim().isEmpty) {
                                  return;
                                }

                                // Store context in a local variable before async operation
                                final currentContext = context;

                                await ScoreManager.setCurrentUsername(
                                  _usernameController.text.trim(),
                                );

                                if (!mounted) return;

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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

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
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
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
                          tooltip: 'Meu Score',
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
                      Expanded(
                        child: ListView(
                          children: [
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
                                    color: const Color(0xFF10B981),
                                    points: '+10/-5 pontos',
                                    icon: Icons.network_wifi_1_bar,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
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
                                    color: const Color(0xFFF59E0B),
                                    points: '+20/-10 pontos',
                                    icon: Icons.network_wifi_2_bar,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
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
                                    color: const Color(0xFFEF4444),
                                    points: '+30/-15 pontos',
                                    icon: Icons.network_wifi_3_bar,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
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
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              children: [
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

class QuizScreen extends StatefulWidget {
  final int level;

  const QuizScreen({super.key, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late List<NetworkQuestion> questions;
  int _currentQuestionIndex = 0;
  int _sessionScore = 0;
  int? _selectedOptionIndex;
  bool _answered = false;
  bool _showNextButton = false;
  bool _isCorrect = false;
  late AnimationController _fadeController;
  late AnimationController _scoreController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800), // Aumentado
      vsync: this,
    );
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Aumentado
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.elasticOut),
    );

    final generator = NetworkQuizGenerator();
    questions =
        generator.generateQuestionsForLevel(widget.level).take(5).toList();
    _fadeController.forward();
  }

  void _answerQuestion(int selectedIndex) async {
    if (_answered) return;

    setState(() {
      _selectedOptionIndex = selectedIndex;
      _answered = true;

      // Verificar se a resposta está correta
      _isCorrect =
          questions[_currentQuestionIndex].options[selectedIndex] ==
          questions[_currentQuestionIndex].correctAnswer;

      // Atualizar pontuação conforme enunciado
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

    // Feedback visual animado para resposta correta
    if (_isCorrect) {
      await _scoreController.forward();
      await _scoreController.reverse();
    }

    // Aguardar um tempo para o usuário ver o resultado
    await Future.delayed(const Duration(milliseconds: 800));

    // Mostrar o botão (tanto para correto quanto incorreto)
    if (mounted) {
      setState(() {
        _showNextButton = true;
      });
    }
  }

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

  void _finishQuiz() async {
    // Store context before async operation
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
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
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

                            Expanded(
                              child: ListView.builder(
                                itemCount: question.options.length,
                                itemBuilder: (context, index) {
                                  final option = question.options[index];
                                  final isCorrect =
                                      option == question.correctAnswer;
                                  final isSelected =
                                      index == _selectedOptionIndex;

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

class QuizResultScreen extends StatelessWidget {
  final int level;
  final int sessionScore;
  final int totalQuestions;
  final int correctAnswers;

  const QuizResultScreen({
    super.key,
    required this.level,
    required this.sessionScore,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final isPass = sessionScore > 0;
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
                      Icon(
                        isPass ? Icons.check_circle : Icons.error,
                        size: 80,
                        color: color,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isPass ? 'Parabéns!' : 'Tente Novamente',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nível $level Concluído',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '$correctAnswers/$totalQuestions corretas',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pontuação: ${sessionScore >= 0 ? '+' : ''}$sessionScore',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
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

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Score')),
      body: FutureBuilder<int>(
        future: ScoreManager.getCurrentUserScore(),
        builder: (context, scoreSnapshot) {
          final username = ScoreManager.getCurrentUsername();

          if (scoreSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final score = scoreSnapshot.data ?? 0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Jogador: ${username ?? 'N/A'}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pontuação Atual: $score',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    child: const Text('Definir Nome de Usuário'),
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

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 5 Jogadores')),
      body: FutureBuilder(
        future: ScoreManager.getTopScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final topScores = snapshot.data ?? [];

          if (topScores.isEmpty) {
            return const Center(child: Text('Nenhum score registrado ainda.'));
          }

          return ListView.builder(
            itemCount: topScores.length,
            itemBuilder: (context, index) {
              final entry = topScores[index];

              // Define a custom color for the top 3
              Color rankColor;
              if (index == 0) {
                rankColor = Colors.amber; // Gold
              } else if (index == 1) {
                rankColor = Colors.grey; // Silver
              } else if (index == 2) {
                rankColor = Color(0xFFCD7F32); // Bronze (custom hex color)
              } else {
                rankColor = Colors.white; // Default
              }

              return ListTile(
                leading: Text(
                  '${index + 1}º',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                  ),
                ),
                title: Text(
                  entry['username'] ?? 'Unknown',
                  style: const TextStyle(color: Colors.white),
                ),
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

class IpConverterScreen extends StatefulWidget {
  const IpConverterScreen({super.key});

  @override
  _IpConverterScreenState createState() => _IpConverterScreenState();
}

class _IpConverterScreenState extends State<IpConverterScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _maskOrPrefixController = TextEditingController();
  String _result = '';
  bool _usePrefix = true;

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
              // Campo para IP
              TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'Endereço IP (ex: 192.168.1.10)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Switch entre Prefixo e Máscara
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

              // Campo dinâmico (Prefixo ou Máscara)
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

              // Botões de ação (apenas 2 agora)
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

              // Resultado
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

  bool _isValidSubnetMask(String mask) {
    if (!_isValidIp(mask)) return false;

    final maskInt = ipToInt(mask);
    var foundZero = false;
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
  bool _usePrefix = true;

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
              // Campo para IP 1
              TextField(
                controller: _ip1Controller,
                decoration: const InputDecoration(
                  labelText: 'Primeiro IP (ex: 192.168.1.10)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Campo para IP 2
              TextField(
                controller: _ip2Controller,
                decoration: const InputDecoration(
                  labelText: 'Segundo IP (ex: 192.168.1.20)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Switch entre Prefixo e Máscara
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

              // Campo dinâmico (Prefixo ou Máscara)
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

              // Botão de verificação
              ElevatedButton(
                onPressed: _checkNetwork,
                child: const Text('Verificar Rede'),
              ),
              const SizedBox(height: 24),

              // Resultado
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

  void _checkNetwork() {
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
      final sameNetwork = areInSameNetwork(
        _ip1Controller.text,
        _ip2Controller.text,
        prefixLength,
      );

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
