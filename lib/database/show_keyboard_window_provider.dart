import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:switchsoulmonarch/database/database_provider.dart';
import 'package:switchsoulmonarch/state/hotkey_holder_state.dart';

class SettingDatabaseProvider extends DatabaseProvider {
  @override
  String get databaseName => "ssm.db";

  @override
  String get tableName => "show_keyboard_window";

  @override
  int get version => 1;

  @override
  Map<String, List<String>> get onUpgradeQueries => {
    // '2' : ['ALTER TABLE xxxxx RENAME COLUMN yyyyyyy TO zzzzz;'],
  };

  createDatabase(Database db, int version) => db.execute(
    """
          CREATE TABLE $tableName(
            key TEXT DEFAULT "",
            modifiers TEXT DEFAULT ""
          )
        """,
  );

  Future<int> insert(SsmKeyCombo wHotKey) async {
    // // Delete the database
    // var databasesPath = await getDatabasesPath();
    // String path = databasesPath+ 'ssm.db';
    // await deleteDatabase(path);


    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    return await database!.insert(provider.tableName, wHotKey.toMap());
  }

  // Future<int> update(WindowHotKey setting) async {
  //   final SettingDatabaseProvider provider = SettingDatabaseProvider();
  //   final database = await (provider.database);
  //   return await database!.update(provider.tableName, setting.toMap());
  // }

  Future<int> delete(SsmKeyCombo setting) async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    return await database!.delete(provider.tableName);
  }

  Future<SsmKeyCombo?> get() async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    final List<Map<String, dynamic>> maps =
    await database!.query(tableName);
    if (maps.length == 0) {
      return null;
    }
    final setting = maps[0];
    print(setting);
    return SsmKeyCombo().fromMap(setting);
  }
}

Future<SsmKeyCombo?> getKeyCombo() async {
  final SettingDatabaseProvider provider = SettingDatabaseProvider();
  final database = await (provider.database);
  final List<Map<String, dynamic>> maps = await database!.query(provider.tableName);
  if (maps.length == 0) {
    return null;
  }
  final setting = maps[0];
  return SsmKeyCombo().fromMap(setting);
}
