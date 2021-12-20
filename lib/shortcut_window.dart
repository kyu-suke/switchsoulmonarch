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
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // call swift code
  static const platform = MethodChannel('samples.flutter.dev/hoge');

  ShortcutApps? _apps = {};

  final Map<ShortcutActivator, Intent> _shortcuts = {
    LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyA): const Hoge(),
    LogicalKeySet(LogicalKeyboardKey.lang1): const IncrementIntent(),
    LogicalKeySet(LogicalKeyboardKey.lang2): const IncrementIntent(),
    LogicalKeySet(LogicalKeyboardKey.lang3): const IncrementIntent(),
    LogicalKeySet(LogicalKeyboardKey.lang4): const IncrementIntent(),
    LogicalKeySet(LogicalKeyboardKey.lang5): const IncrementIntent(),
  };

  final Map<Type, Action<Intent>> _actions = {
    IncrementIntent: CallbackAction<IncrementIntent>(
        onInvoke: (IncrementIntent intent) => print("AAA")),
    LaunchAppIntent: CallbackAction<LaunchAppIntent>(
        onInvoke: (LaunchAppIntent intent) async {
      print(intent.path);
      final result = await platform.invokeMethod('launch', <String, dynamic>{
        "path": intent.path,
      });
    }),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _icons = watch(appsStateNotifier).apps ?? {};

        print("==~~~~~~~=======~~~~~~~~=~=");
        print(_icons);
        _icons.forEach((key, value) {
          var path = value.path.split("/").toList();
          var url = Uri.decodeFull(path[path.length - 2]);
          _shortcuts[value.encode!] = LaunchAppIntent(url);
        });
        return Shortcuts(
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
        );
      },
    );
  }
}
