import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:switchsoulmonarch/database/window_hotkey_provider.dart';

part 'window_hotkey_state.freezed.dart';

@freezed
abstract class WindowHotKeyState with _$WindowHotKeyState {
  factory WindowHotKeyState({
    @Default("") String hotKey,
  }) = _WindowHotKeyState;
}

class WindowHotKeyStateNotifier extends StateNotifier<WindowHotKeyState> {
  WindowHotKeyStateNotifier() : super(WindowHotKeyState());

  final settingDatabaseProvider = SettingDatabaseProvider();

  void set(WindowHotKey windowHotKey) {
    state = state.copyWith(
      hotKey: windowHotKey.hotKey,
    );
  }

  void removePostTypes(String type) async {
    state = state.copyWith(hotKey: "");
    await _save();
  }

  String get hotKey => state.hotKey;

  Future<void> _save() async {
    await settingDatabaseProvider.update(WindowHotKey(
      hotKey: state.hotKey,
    ));
  }
}

class WindowHotKey {
  final String hotKey;

  WindowHotKey({this.hotKey = ""});

  Map<String, dynamic> toMap() {
    return {
      'hotKey': hotKey,
    };
  }

  WindowHotKey fromMap(Map<String, dynamic> map) {
    return WindowHotKey(hotKey: map["hotKey"]);
  }
}
