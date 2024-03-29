import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider {
  Database? _instance;

  String get databaseName => "ssm.db";

  String get tableName;

  int get _version => 2;

  final onUpgradeQueries = {
    '1': [
      'CREATE TABLE show_keyboard_window ( key TEXT DEFAULT "", modifiers TEXT DEFAULT "")'
    ],
    '2': [
      'CREATE TABLE apps (key TEXT DEFAULT "", iconBase64 TEXT DEFAULT "", path TEXT DEFAULT "")'
    ],
  };

  Future<Database?> get database async {
    var databasesPath = await getDatabasesPath();
    print(databasesPath);

    _instance ??= await openDatabase(
      join(
        await getDatabasesPath(),
        databaseName,
      ),
      onCreate: (Database db, int version) async {
        for (var i = 1; onUpgradeQueries[i.toString()] != null; i++) {
          var queries = onUpgradeQueries[i.toString()];
          if (queries == null) continue;
          for (String query in queries) {
            await db.execute(query);
          }
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion + 1; i <= newVersion; i++) {
          var queries = onUpgradeQueries[i.toString()];
          if (queries == null) continue;
          for (String query in queries) {
            await db.execute(query);
          }
        }
      },
      version: _version,
    );
    // TODO 毎回openしてる？
    print("OPEN DB?");
    return _instance;
  }

  createDatabase(Database db, int version) => db.execute(
        """
          CREATE TABLE show_keyboard_window (
            key TEXT DEFAULT "",
            modifiers TEXT DEFAULT ""
          )
        """,
      );
}
