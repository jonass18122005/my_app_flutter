import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            correo TEXT UNIQUE,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE resenas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            estrellas INTEGER,
            comentario TEXT,
            autor TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS usuarios(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT,
              correo TEXT UNIQUE,
              password TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS resenas(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              estrellas INTEGER,
              comentario TEXT
            )
          ''');
        }
        if (oldVersion < 3) {
          try {
            await db.execute('ALTER TABLE resenas ADD COLUMN autor TEXT');
          } catch (e) {
            print('onUpgrade add autor column ignored: $e');
          }
        }
      },
    );
  }


  static Future<Map<String, dynamic>?> registrarUsuario(
      String nombre, String correo, String password) async {
    if (nombre.trim().isEmpty || correo.trim().isEmpty || password.trim().isEmpty) {
      return null;
    }

    final regex = RegExp(r'^[a-zA-Z0-9]{8}$');
    if (!regex.hasMatch(password)) {
      return null;
    }

    try {
      final db = await database;

      final existing = await db.query('usuarios', where: 'correo = ?', whereArgs: [correo]);
      if (existing.isNotEmpty) return null;

      final id = await db.transaction<int>((txn) async {
        final insertedId = await txn.insert('usuarios', {
          'nombre': nombre,
          'correo': correo,
          'password': password,
        });
        return insertedId;
      });

      return {
        'id': id,
        'nombre': nombre,
        'correo': correo,
      };
    } on DatabaseException catch (e) {
      print('DB error registrarUsuario: $e');
      return null;
    } catch (e) {
      print('Unknown error registrarUsuario: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> login(
      String correo, String password) async {
    final db = await database;
    final res = await db.query(
      'usuarios',
      where: 'correo = ? AND password = ?',
      whereArgs: [correo, password],
    );
    return res.isNotEmpty ? res.first : null;
  }


  static Future<void> insertarResena(int estrellas, String comentario, {String? autor}) async {
    final db = await database;
    await db.insert('resenas', {
      'estrellas': estrellas,
      'comentario': comentario,
      'autor': autor ?? 'Usuario',
    });
  }

  static Future<List<Map<String, dynamic>>> obtenerResenas() async {
    final db = await database;
    return await db.query('resenas', orderBy: 'id DESC');
  }

  static Future<List<Map<String, dynamic>>> debugListUsuarios() async {
    try {
      final db = await database;
      final res = await db.query('usuarios', orderBy: 'id DESC');
      print('DEBUG usuarios: $res');
      return res;
    } catch (e) {
      print('DEBUG error listar usuarios: $e');
      return [];
    }
  }
}
