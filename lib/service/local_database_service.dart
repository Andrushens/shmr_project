import 'package:path/path.dart';
import 'package:shmr/utils/const.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataBaseService {
  static const databaseName = ConstLocal.databaseName;
  static Database? _database;

  Future<Database> getInstance() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (db, version) {
        return db.execute(ConstLocal.createTasksTable);
      },
    );
    return _database!;
  }

  Future<Database> get database async {
    if (_database == null) {
      return getInstance();
    } else {
      return _database!;
    }
  }
}
