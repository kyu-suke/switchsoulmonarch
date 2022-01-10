import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:switchsoulmonarch/database/apps_provider.dart';

part 'apps_state.freezed.dart';

typedef ShortcutApps = Map<String, ShortcutApp>;

@freezed
abstract class AppsState with _$AppsState {
  factory AppsState({
    @Default(null) ShortcutApps? apps,
  }) = _AppsState;
}

class AppsStateNotifier extends StateNotifier<AppsState> {
  AppsStateNotifier() : super(AppsState());

  final appsProvider = AppsProvider();

  ShortcutApps? get apps => state.apps;

  void setAll(ShortcutApps apps) {
    state = state.copyWith(apps: apps);
  }

  void set(ShortcutApp app) {
    var apps = state.apps ?? {};
    apps[app.key] = app;
    setAll(apps);
  }

  Future<void> register(ShortcutApp app) async {
    set(app);
    await _delete(app.key);
    await _insert(app);
  }

  Future<void> delete(String key) async {
    await _delete(key);
    var apps = state.apps ?? {};
    apps.removeWhere((k, v) => k == key);
    setAll(apps);
  }

  Future<void> _delete(String key) async {
    await appsProvider.delete(key);
  }

  Future<void> _insert(ShortcutApp app) async {
    await appsProvider.insert(app);
  }
}

class ShortcutApp {
  String key;
  Uint8List icon;
  String path;

  ShortcutApp({required this.key, required this.icon, required this.path});

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'iconBase64': base64Encode(icon),
      'path': path,
    };
  }

  static ShortcutApp fromMap(Map<String, dynamic> map) {
    return ShortcutApp(
        key: map["key"],
        icon: base64Decode(map["iconBase64"]),
        path: map["path"]);
  }

  static ShortcutApps fromListMap(List<Map<String, dynamic>> maps) {
    return maps.fold({}, (previousValue, element) {
      final app = ShortcutApp.fromMap(element);
      previousValue[app.key] = app;
      return previousValue;
    });
  }

  LogicalKeySet? get encode {
    switch (key) {
      case "1":
        return LogicalKeySet(LogicalKeyboardKey.digit1);
      case "2":
        return LogicalKeySet(LogicalKeyboardKey.digit2);
      case "3":
        return LogicalKeySet(LogicalKeyboardKey.digit3);
      case "4":
        return LogicalKeySet(LogicalKeyboardKey.digit4);
      case "5":
        return LogicalKeySet(LogicalKeyboardKey.digit5);
      case "6":
        return LogicalKeySet(LogicalKeyboardKey.digit6);
      case "7":
        return LogicalKeySet(LogicalKeyboardKey.digit7);
      case "8":
        return LogicalKeySet(LogicalKeyboardKey.digit8);
      case "9":
        return LogicalKeySet(LogicalKeyboardKey.digit9);
      case "0":
        return LogicalKeySet(LogicalKeyboardKey.digit0);
      case "-":
        return LogicalKeySet(LogicalKeyboardKey.minus);
      case "^":
        return LogicalKeySet(LogicalKeyboardKey.caret);
      case "\\":
        return LogicalKeySet(LogicalKeyboardKey.backslash);
      case "q":
        return LogicalKeySet(LogicalKeyboardKey.keyQ);
      case "w":
        return LogicalKeySet(LogicalKeyboardKey.keyW);
      case "e":
        return LogicalKeySet(LogicalKeyboardKey.keyE);
      case "r":
        return LogicalKeySet(LogicalKeyboardKey.keyR);
      case "t":
        return LogicalKeySet(LogicalKeyboardKey.keyT);
      case "y":
        return LogicalKeySet(LogicalKeyboardKey.keyY);
      case "u":
        return LogicalKeySet(LogicalKeyboardKey.keyU);
      case "i":
        return LogicalKeySet(LogicalKeyboardKey.keyI);
      case "o":
        return LogicalKeySet(LogicalKeyboardKey.keyO);
      case "p":
        return LogicalKeySet(LogicalKeyboardKey.keyP);
      case "@":
        return LogicalKeySet(LogicalKeyboardKey.at);
      case "[":
        return LogicalKeySet(LogicalKeyboardKey.bracketLeft);
      case "a":
        return LogicalKeySet(LogicalKeyboardKey.keyA);
      case "s":
        return LogicalKeySet(LogicalKeyboardKey.keyS);
      case "d":
        return LogicalKeySet(LogicalKeyboardKey.keyD);
      case "f":
        return LogicalKeySet(LogicalKeyboardKey.keyF);
      case "g":
        return LogicalKeySet(LogicalKeyboardKey.keyG);
      case "h":
        return LogicalKeySet(LogicalKeyboardKey.keyH);
      case "j":
        return LogicalKeySet(LogicalKeyboardKey.keyJ);
      case "k":
        return LogicalKeySet(LogicalKeyboardKey.keyK);
      case "l":
        return LogicalKeySet(LogicalKeyboardKey.keyL);
      case ";":
        return LogicalKeySet(LogicalKeyboardKey.semicolon);
      case ":":
        return LogicalKeySet(LogicalKeyboardKey.colon);
      case "]":
        return LogicalKeySet(LogicalKeyboardKey.braceRight);
      case "z":
        return LogicalKeySet(LogicalKeyboardKey.keyZ);
      case "x":
        return LogicalKeySet(LogicalKeyboardKey.keyX);
      case "c":
        return LogicalKeySet(LogicalKeyboardKey.keyC);
      case "v":
        return LogicalKeySet(LogicalKeyboardKey.keyV);
      case "b":
        return LogicalKeySet(LogicalKeyboardKey.keyB);
      case "n":
        return LogicalKeySet(LogicalKeyboardKey.keyN);
      case "m":
        return LogicalKeySet(LogicalKeyboardKey.keyM);
      case ",":
        return LogicalKeySet(LogicalKeyboardKey.comma);
      case ".":
        return LogicalKeySet(LogicalKeyboardKey.period);
      case "/":
        return LogicalKeySet(LogicalKeyboardKey.slash);
      case "_":
        return LogicalKeySet(LogicalKeyboardKey.underscore);
      // TODO: control, meta, fn, etc
    }
    return null;
  }
}

final appsStateNotifier = StateNotifierProvider<AppsStateNotifier, AppsState>(
    (ref) => AppsStateNotifier());
