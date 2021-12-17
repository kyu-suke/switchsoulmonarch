import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_holder/hotkey_holder.dart';
import 'package:switchsoulmonarch/main.dart';
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
  HotKeyHolderKeyCombo? _keyCombo;
  HotKeyHolder hkeyHolder = HotKeyHolder(
      hotKeyName: "shortcutA",
      keyCombo: null,
      onInput: (a) {},
      onDelete: (a) {},
      event: () {
        print("this is shortcut A");
      });

  @override
  void initState() {
    super.initState();
  }

  void insertKeyCombo(HotKeyHolderKeyCombo keyCombo) {
    print(keyCombo.modifiers);
    print(keyCombo.key);
    context.read(windowHotKeyStateNotifier.notifier).register(
        HotKeyHolderKeyCombo(key: keyCombo.key, modifiers: keyCombo.modifiers));
  }

  void deleteKeyCombo() {
    print(_keyCombo);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final keyCombo = watch(windowHotKeyStateNotifier).keyCombo;
        HotKeyHolderKeyCombo? kc;
        if (keyCombo != null) {
          kc = HotKeyHolderKeyCombo(
              key: keyCombo.key, modifiers: keyCombo.modifiers);
        }
        return HotKeyHolder(
            hotKeyName: "shortcutA",
            keyCombo: kc,
            onInput: insertKeyCombo,
            onDelete: deleteKeyCombo,
            event: () {
              this.showFunc();
              print("this is shortcut A");
            });
      },
    );
  }
}
