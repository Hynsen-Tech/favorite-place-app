import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _db;
  final String _dbName = 'places.db';

  DBHelper._internal();
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  Future<String> getDatabasePath() async {
    final String dbPath = await getDatabasesPath();
    return dbPath;
  }

  Future<Database> get db async {
    final String dbPath = await getDatabasePath();
    _db ??= await openDatabase(join(dbPath, _dbName),
          onCreate: createDatabase, version: 1);
    return _db!;
  }

  Future<void> createDatabase(Database db, int version) async {
    await db.execute('''CREATE TABLE places (
                        id INTEGER PRIMARY KEY AUTOINCREMENT, 
                        title TEXT, 
                        image TEXT, 
                        lat REAL, 
                        lng REAL, 
                        address TEXT)''');
  }
}
