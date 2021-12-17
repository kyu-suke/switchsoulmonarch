import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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

  Future<ShortcutApps?> get() async {
    return await _get();
  }

  Future<void> register(ShortcutApp app) async {
    set(app);
    await _delete(app.key);
    await _insert(app);
  }

  Future<void> _delete(String key) async {
    await appsProvider.delete(key);
  }

  Future<void> _insert(ShortcutApp app) async {
    await appsProvider.insert(app);
  }

  Future<ShortcutApps?> _get() async {
    // return await AppsProvider.get();
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
       'iconBase64':base64Encode(icon),
       'path':path,
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
}

final appsStateNotifier = StateNotifierProvider<AppsStateNotifier, AppsState>(
    (ref) => AppsStateNotifier());
