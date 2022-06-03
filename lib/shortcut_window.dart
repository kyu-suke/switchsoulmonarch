import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchsoulmonarch/keyboard.dart';
import 'package:switchsoulmonarch/state/apps_state.dart';

class ShortcutWindow extends StatelessWidget {
  ShortcutWindow({Key? key}) : super(key: key);

  static const platform = MethodChannel('switch.soul.monarch/channel');

  final Map<ShortcutActivator, String> _shortcuts = {};

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyUpEvent) return;
    if (_shortcuts[LogicalKeySet(event.data.logicalKey)] == null) return;
    platform.invokeMethod('launch', <String, dynamic>{
      "path": _shortcuts[LogicalKeySet(event.data.logicalKey)],
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _icons = ref.watch(appsStateNotifier.notifier).apps ?? {};

        _icons.forEach((key, value) {
          var path = value.path.split("/").toList();
          var url = Uri.decodeFull(path[path.length - 2]);
          if (value.encode != null) {
            _shortcuts[value.encode!] = url;
          }
        });
        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _handleKeyEvent,
          child: Focus(
            autofocus: true,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      KeyboardPage(
                        fn: () {},
                        icons: _icons,
                        mode: "shortcuts",
                      ),
                    ],
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
