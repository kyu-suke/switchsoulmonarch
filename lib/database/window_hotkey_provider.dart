import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:switchsoulmonarch/database/database_provider.dart';
import 'package:switchsoulmonarch/state/window_hotkey_state.dart';

class SettingDatabaseProvider extends DatabaseProvider {
  @override
  String get databaseName => "ssm.db";

  @override
  String get tableName => "show_window";

  @override
  int get version => 1;

  @override
  Map<String, List<String>> get onUpgradeQueries => {
        // '2' : ['ALTER TABLE xxxxx RENAME COLUMN yyyyyyy TO zzzzz;'],
      };

  createDatabase(Database db, int version) => db.execute(
        """
          CREATE TABLE $tableName(
            hotKey TEXT DEFAULT ""
          )
        """,
      );

  Future<int> insert(WindowHotKey wHotKey) async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    return await database!.insert(provider.tableName, wHotKey.toMap());
  }

  // Future<int> update(WindowHotKey setting) async {
  //   final SettingDatabaseProvider provider = SettingDatabaseProvider();
  //   final database = await (provider.database);
  //   return await database!.update(provider.tableName, setting.toMap());
  // }

  Future<int> delete(WindowHotKey setting) async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    return await database!
        .delete(provider.tableName);
  }

  Future<WindowHotKey?> get() async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    final List<Map<String, dynamic>> maps = await database!.query('show_window');
    if (maps.length == 0) {
      return null;
    }
    final setting = maps[0];
    return WindowHotKey().fromMap(setting);
  }
}
