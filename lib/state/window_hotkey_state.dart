import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:switchsoulmonarch/database/window_hotkey_provider.dart';

part 'window_hotkey_state.freezed.dart';

@freezed
abstract class WindowHotKeyState with _$WindowHotKeyState {
  factory WindowHotKeyState({
    @Default(null) HotKey? hotKey,
  }) = _WindowHotKeyState;
}

class WindowHotKeyStateNotifier extends StateNotifier<WindowHotKeyState> {
  WindowHotKeyStateNotifier() : super(WindowHotKeyState());

  final settingDatabaseProvider = SettingDatabaseProvider();

  void init() async {
    final wHotKey = await _get();
    print("??????????????????????????????????????????/");
    print(wHotKey);
  }

  void register(HotKey hotKey) async {
    state = state.copyWith(hotKey: hotKey);
    await _delete();
    await _insert();
  }

  // void removePostTypes(String type) async {
  //   state = state.copyWith(hotKey: "");
  //   await _save();
  // }

  HotKey? get hotKey => state.hotKey;

  Future<void> _delete() async {
    await settingDatabaseProvider.delete(WindowHotKey(
      hotKey: state.hotKey,
    ));
  }

  Future<void> _insert() async {
    await settingDatabaseProvider.insert(WindowHotKey(
      hotKey: state.hotKey,
    ));
  }

  Future<WindowHotKey?> _get() async {
    return await settingDatabaseProvider.get();
  }
}

class WindowHotKey {
  final HotKey? hotKey;

  WindowHotKey({this.hotKey});

  Map<String, dynamic> toMap() {
    print("Z");
    print(hotKey);
    print("ZX");
    print(hotKey?.toJson());
    print("ZC");
    print(jsonEncode(hotKey?.toJson()));
    return {
      'hotKey': jsonEncode(hotKey?.toJson()),
    };
  }

  WindowHotKey fromMap(Map<String, dynamic> map) {
    print("A");
    print(map["hotKey"]);
    print("AB");
    print(jsonDecode(map["hotKey"]));
    print("AC");
    return WindowHotKey(hotKey: HotKey.fromJson(jsonDecode(map["hotKey"])));
  }
}

final windowHotKeyStateNotifier =
    StateNotifierProvider<WindowHotKeyStateNotifier, WindowHotKeyState>(
        (ref) => WindowHotKeyStateNotifier());
