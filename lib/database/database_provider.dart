import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseProvider {
  Database? _instance;

  String get databaseName;

  String get tableName;

  int get version;

  Map<String, List<String>>  get onUpgradeQueries;

  Future<Database?> get database async {
    if (_instance == null) {
      _instance = await openDatabase(
        join(
          await getDatabasesPath(),
          databaseName,
        ),
        onCreate: createDatabase,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          print("===============");
          print(db);
          print(oldVersion);
          print(newVersion);
          for (var i = oldVersion + 1; i <= newVersion; i++) {
            var queries = onUpgradeQueries[i.toString()];
            if (queries == null) continue;
            for (String query in queries) {
              await db.execute(query);
            }
          }
        },
        version: version,
      );
    }
    return _instance;
  }

  createDatabase(Database db, int version);
}
