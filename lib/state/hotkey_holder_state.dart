import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_holder/hotkey_holder.dart';
import 'package:magnetica/magnetica.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:switchsoulmonarch/database/show_keyboard_window_provider.dart';

part 'hotkey_holder_state.freezed.dart';

@freezed
abstract class HotKeyHolderState with _$HotKeyHolderState {
  factory HotKeyHolderState({
    @Default(null) KeyCombo? keyCombo,
  }) = _HotKeyHolderState;
}

class HotKeyHolderStateNotifier extends StateNotifier<HotKeyHolderState> {
  HotKeyHolderStateNotifier() : super(HotKeyHolderState());

  final settingDatabaseProvider = SettingDatabaseProvider();

  KeyCombo? get keyCombo => state.keyCombo;

  void set(HotKeyHolderKeyCombo setting) {
    state = state.copyWith(keyCombo: setting);
  }

  Future<SsmKeyCombo?> get() async {
    return await _get();
  }

  Future<void> register(HotKeyHolderKeyCombo keyCombo) async {
    state = state.copyWith(keyCombo: keyCombo);
    await _delete();
    await _insert();
  }

  Future<void> _delete() async {
    await settingDatabaseProvider.delete();
  }

  Future<void> _insert() async {
    await settingDatabaseProvider.insert(SsmKeyCombo(
        keyCombo: HotKeyHolderKeyCombo(
            key: keyCombo!.key, modifiers: keyCombo!.modifiers)));
  }

  Future<SsmKeyCombo?> _get() async {
    return await settingDatabaseProvider.get();
  }
}

class SsmKeyCombo {
  HotKeyHolderKeyCombo? keyCombo;

  SsmKeyCombo({this.keyCombo});

  Map<String, dynamic> toMap() {
    return {
      'key': keyCombo?.key.encode(),
      'modifiers':
          jsonEncode(keyCombo?.modifiers.map((e) => e.encode()).toList()),
    };
  }

  SsmKeyCombo fromMap(Map<String, dynamic> map) {
    return SsmKeyCombo(
        keyCombo: HotKeyHolderKeyCombo(
            key: KeyCharacterExtension.fromString(map["key"]),
            modifiers: (jsonDecode(map["modifiers"]).cast<int>() as List<int>)
                .map((e) {
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
            }).toList()));
  }
}

final windowHotKeyStateNotifier =
    StateNotifierProvider<HotKeyHolderStateNotifier, HotKeyHolderState>(
        (ref) => HotKeyHolderStateNotifier());
