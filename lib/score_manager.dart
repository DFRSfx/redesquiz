import 'database_helper.dart';

/// Classe de utilitário para gerir o utilizador atual e as pontuações no quiz.
class ScoreManager {
  static String? _currentUsername;

  /// Define o nome de utilizador atual e garante que existe na base de dados.
  static Future<void> setCurrentUsername(String username) async {
    _currentUsername = username;
    // Inicializa o utilizador na base de dados com score 0 se não existir
    final dbHelper = DatabaseHelper.instance;
    final currentScore = await dbHelper.getScore(username);
    if (currentScore == null) {
      await dbHelper.upsertScore(username, 0);
    }
  }

  /// Obtém o nome de utilizador atual.
  static String? getCurrentUsername() {
    return _currentUsername;
  }

  /// Obtém a pontuação do utilizador atual.
  static Future<int> getCurrentUserScore() async {
    if (_currentUsername == null) return 0;
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getScore(_currentUsername!) ?? 0;
  }

  /// Atualiza a pontuação do utilizador atual.
  static Future<void> updateCurrentUserScore(int score) async {
    if (_currentUsername != null) {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.upsertScore(_currentUsername!, score);
    }
  }

  /// Adiciona pontos à pontuação do utilizador atual.
  static Future<void> addToCurrentUserScore(int pointsToAdd) async {
    if (_currentUsername != null) {
      final dbHelper = DatabaseHelper.instance;
      final currentScore = await getCurrentUserScore();
      await dbHelper.upsertScore(_currentUsername!, currentScore + pointsToAdd);
    }
  }

  /// Obtém as melhores pontuações.
  static Future<List<Map<String, dynamic>>> getTopScores({
    int limit = 5,
  }) async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getTopScores(limit: limit);
  }

  /// Limpa o utilizador atual (logout).
  static void clearCurrentUser() {
    _currentUsername = null;
  }
}
