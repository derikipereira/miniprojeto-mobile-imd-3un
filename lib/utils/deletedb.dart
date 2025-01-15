import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> deleteDatabaseFile() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'places_new.db');
  try {
    await deleteDatabase(path);
    print('Banco de dados deletado com sucesso!');
  } catch (e) {
    print('Erro ao deletar o banco de dados: $e');
  }
}
