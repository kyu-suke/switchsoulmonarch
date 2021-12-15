import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:magnetica/magnetica.dart';
import 'package:hotkey_holder/hotkey_holder.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:switchsoulmonarch/database/show_keyboard_window_provider.dart';

part 'hotkey_holder_state.freezed.dart';

@freezed
abstract class HotKeyHolderState with _$HotKeyHolderState {
  factory HotKeyHolderState({
    @Default(null) String? hotKeyName,
    @Default(null) KeyCombo? keyCombo,
    @Default(null) Function? event,
  }) = _HotKeyHolderState;
}


class HotKeyHolderStateNotifier extends StateNotifier<HotKeyHolderState> {
  HotKeyHolderStateNotifier() : super(HotKeyHolderState());

  final settingDatabaseProvider = SettingDatabaseProvider();
  // HotKey? get hotKey => state.hotKey;
  String? get hotKeyName => state.hotKeyName;
  KeyCombo? get keyCombo => state.keyCombo;
  Function? get event => state.event;

  void set(HotKeyHolderKeyCombo setting) {
    state = state.copyWith(
        keyCombo: setting);
  }

  Future<SsmKeyCombo?> get() async {
    return await _get();
  }

  Future<void> init() async {
    final keyCombo = await _get();
    state = state.copyWith(keyCombo: keyCombo?.keyCombo);
  }
  Future<void> register(String hotKeyName, HotKeyHolderKeyCombo keyCombo, Function event) async {
    state = state.copyWith(hotKeyName: hotKeyName, keyCombo: keyCombo, event: event);
    await _delete();
    await _insert();
  }

  // void removePostTypes(String type) async {
  //   state = state.copyWith(hotKey: "");
  //   await _save();
  // }


  Future<void> _delete() async {
    await settingDatabaseProvider.delete(SsmKeyCombo(
      keyCombo: null,
    ));
  }

  Future<void> _insert() async {
    await settingDatabaseProvider.insert(SsmKeyCombo(keyCombo: HotKeyHolderKeyCombo(key: keyCombo!.key, modifiers: keyCombo!.modifiers)));
  }

  Future<SsmKeyCombo?> _get() async {
    return await settingDatabaseProvider.get();
  }
}

class SsmKeyCombo {
  HotKeyHolderKeyCombo? keyCombo;

  SsmKeyCombo({ this.keyCombo});

  Map<String, dynamic> toMap() {
    return {
      'key': keyCombo?.key.encode(),
      'modifiers': jsonEncode(keyCombo?.modifiers.map((e) => e.encode()).toList()),
    };
  }

  SsmKeyCombo fromMap(Map<String, dynamic> map) {
    return SsmKeyCombo(
      keyCombo: HotKeyHolderKeyCombo(
        key: KeyCharacterExtension.fromString(map["key"]) ,
        modifiers: (jsonDecode(map["modifiers"]).cast<int>() as List<int>).map((e) {
          switch (e) {
            case 512:
              return Modifier.shift;
            case 4096:
              return Modifier.control;
            case 2048:
              return Modifier.option;
            case 256:
              return Modifier.command;
            default:
              return Modifier.command;
          }
        }).toList()
      )
    );
    // return SsmKeyCombo(hotKey: HotKey.fromJson(jsonDecode(map["hotKey"])));
  }
}

final windowHotKeyStateNotifier =
StateNotifierProvider<HotKeyHolderStateNotifier, HotKeyHolderState>(
        (ref) => HotKeyHolderStateNotifier());
// final tmblPostStateProvider =
// StateNotifierProvider<TmblPostStateNotifier, TmblPostState>(
//         (ref) => TmblPostStateNotifier());
