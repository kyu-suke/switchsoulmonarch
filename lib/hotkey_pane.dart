import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_holder/hotkey_holder.dart';
import 'package:switchsoulmonarch/state/hotkey_holder_state.dart';

class HotKeyPane extends StatefulWidget {
  const HotKeyPane({Key? key, required Function fn})
      : showFunc = fn,
        super(key: key);

  final Function showFunc;

  @override
  _HotKeyPaneState createState() => _HotKeyPaneState();
}

class _HotKeyPaneState extends State<HotKeyPane> {
  @override
  void initState() {
    super.initState();
  }

  void insertKeyCombo(HotKeyHolderKeyCombo keyCombo, WidgetRef ref) {
    ref.read(windowHotKeyStateNotifier.notifier).register(
        HotKeyHolderKeyCombo(key: keyCombo.key, modifiers: keyCombo.modifiers));
  }

  void deleteKeyCombo() {
    print("delete keyCombo");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final keyCombo = ref.watch(windowHotKeyStateNotifier).keyCombo;
        HotKeyHolderKeyCombo? kc;
        if (keyCombo != null) {
          kc = HotKeyHolderKeyCombo(
              key: keyCombo.key, modifiers: keyCombo.modifiers);
        }
        return HotKeyHolder(
            hotKeyName: "shortcutA",
            keyCombo: kc,
            onInput: (HotKeyHolderKeyCombo keyCombo) {insertKeyCombo(keyCombo, ref);},
            onDelete: deleteKeyCombo,
            event: widget.showFunc);
      },
    );
  }
}
