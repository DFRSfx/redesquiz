import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Helper para aceder e manipular a base de dados SQLite utilizada para guardar pontuações.
class DatabaseHelper {
  static const _databaseName = 'quiz_scores.db';
  static const _databaseVersion = 1;

  static const tableScores = 'scores';
  static const columnId = 'id';
  static const columnUsername = 'username';
  static const columnScore = 'score';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  /// Obtém a instância da base de dados (cria se necessário).
  Future<Database> get database async => _database ??= await _initDatabase();

  /// Inicializa a base de dados SQLite.
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Cria a tabela de pontuações.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableScores (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT NOT NULL,
        $columnScore INTEGER NOT NULL,
        UNIQUE($columnUsername)
      )
    ''');
  }

  /// Cria ou atualiza a pontuação de um utilizador.
  Future<int> upsertScore(String username, int score) async {
    final db = await database;
    return await db.insert(tableScores, {
      columnUsername: username,
      columnScore: score,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Obtém a pontuação de um utilizador.
  Future<int?> getScore(String username) async {
    final db = await database;
    final results = await db.query(
      tableScores,
      columns: [columnScore],
      where: '$columnUsername = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty ? results.first[columnScore] as int? : null;
  }

  /// Obtém as melhores pontuações.
  Future<List<Map<String, dynamic>>> getTopScores({int limit = 5}) async {
    final db = await database;
    return await db.query(
      tableScores,
      orderBy: '$columnScore DESC',
      limit: limit,
    );
  }

  /// Verifica se existe utilizador na base de dados.
  Future<bool> userExists(String username) async {
    final db = await database;
    final results = await db.query(
      tableScores,
      where: '$columnUsername = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty;
  }

  /// Apaga todas as pontuações da base de dados.
  Future<int> clearAllScores() async {
    final db = await database;
    return await db.delete(tableScores);
  }
}
