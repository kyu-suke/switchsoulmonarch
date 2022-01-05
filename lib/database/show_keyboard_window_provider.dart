import 'dart:async';

import 'package:switchsoulmonarch/database/database_provider.dart';
import 'package:switchsoulmonarch/state/hotkey_holder_state.dart';

class SettingDatabaseProvider extends DatabaseProvider {
  @override
  String get tableName => "show_keyboard_window";

  Future<int> insert(SsmKeyCombo keyCombo) async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    return await database!.insert(provider.tableName, keyCombo.toMap());
  }

  Future<int> delete() async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    return await database!.delete(provider.tableName);
  }

  Future<SsmKeyCombo?> get() async {
    final SettingDatabaseProvider provider = SettingDatabaseProvider();
    final database = await (provider.database);
    final List<Map<String, dynamic>> maps = await database!.query(tableName);
    if (maps.isEmpty) {
      return null;
    }
    return SsmKeyCombo().fromMap(maps[0]);
  }
}

Future<SsmKeyCombo?> getKeyCombo() async {
  final SettingDatabaseProvider provider = SettingDatabaseProvider();
  final database = await (provider.database);
  final List<Map<String, dynamic>> maps =
      await database!.query(provider.tableName);
  if (maps.isEmpty) {
    return null;
  }
  return SsmKeyCombo().fromMap(maps[0]);
}
