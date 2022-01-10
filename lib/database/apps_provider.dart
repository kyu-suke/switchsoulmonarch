import 'dart:async';

import 'package:switchsoulmonarch/database/database_provider.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';

class AppsProvider extends DatabaseProvider {
  @override
  String get tableName => "apps";

  Future<int> insert(ShortcutApp app) async {
    final AppsProvider provider = AppsProvider();
    final database = await (provider.database);
    return await database!.insert(provider.tableName, app.toMap());
  }

  Future<int> delete(String key) async {
    final AppsProvider provider = AppsProvider();
    final database = await (provider.database);
    return await database!
        .delete(provider.tableName, where: "key=?", whereArgs: [key]);
  }

  Future<ShortcutApps?> get() async {
    final AppsProvider provider = AppsProvider();
    final database = await (provider.database);
    final List<Map<String, dynamic>> maps = await database!.query(tableName);
    if (maps.isEmpty) {
      return null;
    }
    return ShortcutApp.fromListMap(maps);
  }
}

Future<ShortcutApps?> getApps() async {
  final AppsProvider provider = AppsProvider();
  final database = await (provider.database);
  final List<Map<String, dynamic>> maps =
      await database!.query(provider.tableName);
  if (maps.isEmpty) {
    return null;
  }
  return ShortcutApp.fromListMap(maps);
}
