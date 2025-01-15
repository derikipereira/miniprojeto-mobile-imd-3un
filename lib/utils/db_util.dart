import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {

  static Future<sql.Database> openDatabaseConnection() async {

    final databasePath = await sql.getDatabasesPath();
    final pathToDatabase = path.join(databasePath, 'places.db');

    print('Database path: $pathToDatabase');

    return sql.openDatabase(
      pathToDatabase,
      onCreate: (db, version) {
        print("Creating database and table...");
        return db.execute(
            'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT, phone TEXT, email TEXT, latitude REAL, longitude REAL, address TEXT)'
        ).then((_) {
          print("Table places created successfully");
        });
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.openDatabaseConnection();
    print("Inserting data into table: $table");
    print("Data: $data");
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.openDatabaseConnection();
    print("Getting data from table: $table");
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DbUtil.openDatabaseConnection();
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
