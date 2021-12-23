import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchsoulmonarch/keyboard.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';

class ShortcutWindow extends StatefulWidget {
  const ShortcutWindow({Key? key}) : super(key: key);

  @override
  _ShortcutWindowState createState() => _ShortcutWindowState();
}

class LaunchAppIntent extends Intent {
  const LaunchAppIntent(this.path);

  final String path;
}

class _ShortcutWindowState extends State<ShortcutWindow> {
  static const platform = MethodChannel('samples.flutter.dev/hoge');

  final Map<ShortcutActivator, Intent> _shortcuts = {
    LogicalKeySet(LogicalKeyboardKey.arrowUp): const LaunchAppIntent("a"),
    LogicalKeySet(LogicalKeyboardKey.arrowDown): const LaunchAppIntent("b"),
    LogicalKeySet(LogicalKeyboardKey.keyA): const LaunchAppIntent("c"),
    LogicalKeySet(LogicalKeyboardKey.lang1): const LaunchAppIntent("d"),
    LogicalKeySet(LogicalKeyboardKey.lang2): const LaunchAppIntent("e"),
    LogicalKeySet(LogicalKeyboardKey.lang3): const LaunchAppIntent("f"),
    LogicalKeySet(LogicalKeyboardKey.lang4): const LaunchAppIntent("g"),
    LogicalKeySet(LogicalKeyboardKey.lang5): const LaunchAppIntent("q"),
    LogicalKeySet(LogicalKeyboardKey.tab): const LaunchAppIntent("tab"),
    LogicalKeySet(LogicalKeyboardKey.shiftLeft,LogicalKeyboardKey.keyA): const LaunchAppIntent("shift"),
    LogicalKeySet(LogicalKeyboardKey.metaLeft,LogicalKeyboardKey.keyA): const LaunchAppIntent("meta"),
    LogicalKeySet(LogicalKeyboardKey.controlLeft): const LaunchAppIntent("ctrl"),
    LogicalKeySet(LogicalKeyboardKey.altLeft): const LaunchAppIntent("alt"),
  };

  void _handleKeyEvent(RawKeyEvent event) {
print('Pressed ${event.logicalKey.debugName}');
  }

  final Map<Type, Action<Intent>> _actions = {
    LaunchAppIntent: CallbackAction<LaunchAppIntent>(
        onInvoke: (LaunchAppIntent intent) async {
          print(intent.path);
      await platform.invokeMethod('launch', <String, dynamic>{
        "path": intent.path,
      });
    }),
  };

  @override
  void initState() {
    super.initState();
  }
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _icons = watch(appsStateNotifier).apps ?? {};

        _icons.forEach((key, value) {
          var path = value.path.split("/").toList();
          var url = Uri.decodeFull(path[path.length - 2]);
          _shortcuts[value.encode!] = LaunchAppIntent(url);
        });
        return
            RawKeyboardListener(
              focusNode: _focusNode,
              onKey: _handleKeyEvent,
          child: Shortcuts(
            shortcuts: _shortcuts,
            child: Actions(
              actions: _actions,
              child: Focus(
                autofocus: true,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          KeyboardPage(fn: () {}, icons: _icons),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
