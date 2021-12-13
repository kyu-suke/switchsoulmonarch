import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_holder/hotkey_holder.dart';
import 'package:magnetica/magnetica.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:switchsoulmonarch/state/hotkey_holder_state.dart';

class HotKeyPane extends StatefulWidget {
  const HotKeyPane({Key? key, required Function fn})
      : showFunc = fn,
        super(key: key);

  final Function showFunc;

  @override
  _HotKeyPaneState createState() => _HotKeyPaneState(showFunc: showFunc);
}

class _HotKeyPaneState extends State<HotKeyPane> {
  _HotKeyPaneState({required this.showFunc});

  final Function showFunc;

  @override
  void initState() {
    super.initState();
  }

  void insertKeyCombo() {

  }

  KeyCombo? _keyCombo;
  @override
  Widget build(BuildContext context) {
    context
        .read(windowHotKeyStateNotifier.notifier)
        .get()
        .then((ssmKeyCombo) async {
          print(ssmKeyCombo);
      // if (windowHotKey?.hotKey != null) {
      //   await context
      //       .read(windowHotKeyStateNotifier.notifier)
      //       .register(windowHotKey!.hotKey!);
      //   await HotKeyManager.instance.register(
      //     windowHotKey!.hotKey!,
      //     // keyDownHandler: _keyDownHandler,
      //     keyUpHandler: (HotKey hotKey) {},
      //   );
      // }
    });
    // return _buildBody(context);
    return HotKeyHolder(
        hotKeyName: "shortcutA",
        keyCombo: _keyCombo,
        onInput: insertKeyCombo,
        event: () {
          print("this is shortcut A");
        });
  }
}
