import 'database_helper.dart';

class ScoreManager {
  static String? _currentUsername;

  // Set current username (called from UserNameDialog)
  static Future<void> setCurrentUsername(String username) async {
    _currentUsername = username;
    
    // Initialize user in database with score 0 if they don't exist
    final dbHelper = DatabaseHelper.instance;
    final currentScore = await dbHelper.getScore(username);
    if (currentScore == null) {
      await dbHelper.upsertScore(username, 0);
    }
  }

  // Get current username
  static String? getCurrentUsername() {
    return _currentUsername;
  }

  // Get current user's score
  static Future<int> getCurrentUserScore() async {
    if (_currentUsername == null) return 0;
    
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getScore(_currentUsername!) ?? 0;
  }

  // Update current user's score
  static Future<void> updateCurrentUserScore(int score) async {
    if (_currentUsername != null) {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.upsertScore(_currentUsername!, score);
    }
  }

  // Add to current user's score
  static Future<void> addToCurrentUserScore(int pointsToAdd) async {
    if (_currentUsername != null) {
      final dbHelper = DatabaseHelper.instance;
      final currentScore = await getCurrentUserScore();
      await dbHelper.upsertScore(_currentUsername!, currentScore + pointsToAdd);
    }
  }

  // Get top scores
  static Future<List<Map<String, dynamic>>> getTopScores({int limit = 5}) async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getTopScores(limit: limit);
  }

  // Clear current user (logout)
  static void clearCurrentUser() {
    _currentUsername = null;
  }
}