import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:magnetica/magnetica.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:switchsoulmonarch/database/window_hotkey_provider.dart';

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

  Future<SsmKeyCombo?> get() async {
    return await _get();
  }

  Future<void> init() async {
    final keyCombo = await _get();
    state = state.copyWith(hotKeyName: keyCombo?.hotKeyName, keyCombo: keyCombo?.keyCombo, event: keyCombo?.event);
  }
  Future<void> register(String hotKeyName, KeyCombo keyCombo, Function event) async {
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
      hotKeyName: null, keyCombo: null, event: null,
    ));
  }

  Future<void> _insert() async {
    await settingDatabaseProvider.insert(SsmKeyCombo(hotKeyName: hotKeyName, keyCombo: keyCombo, event: event));
  }

  Future<SsmKeyCombo?> _get() async {
    return await settingDatabaseProvider.get();
  }
}

class SsmKeyCombo {
  // final HotKey? hotKey;
  String? hotKeyName;
  KeyCombo? keyCombo;
  Function? event;

  SsmKeyCombo({this.hotKeyName, this.keyCombo, this.event});

  Map<String, dynamic> toMap() {
    return {
      // 'hotKey': jsonEncode(hotKey?.toJson()),
    };
  }

  SsmKeyCombo fromMap(Map<String, dynamic> map) {
    return SsmKeyCombo();
    // return SsmKeyCombo(hotKey: HotKey.fromJson(jsonDecode(map["hotKey"])));
  }
}

final windowHotKeyStateNotifier =
StateNotifierProvider<HotKeyHolderStateNotifier, HotKeyHolderState>(
        (ref) => HotKeyHolderStateNotifier());
