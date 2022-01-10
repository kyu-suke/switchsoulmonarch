import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // TODO delete keycombo
    print("delete keyCombo");
  }

  static const platform = MethodChannel('switch.soul.monarch/channel');

  void checkForUpdate() {
    try {
      platform.invokeMethod('checkForUpdate', {});
    } on PlatformException catch (e) {
      print(e);
    }
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HotKeyHolder(
                hotKeyName: "shortcutA",
                keyCombo: kc,
                onInput: (HotKeyHolderKeyCombo keyCombo) {
                  insertKeyCombo(keyCombo, ref);
                },
                onDelete: deleteKeyCombo,
                event: widget.showFunc),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              child: const Text("Check for updates"),
              style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  )),
              onPressed: checkForUpdate,
            ),
            // OutlinedButton(
            //   child: Text("初期化。ホットキーとアプリ設定全部消します"),
            //   style: OutlinedButton.styleFrom(
            //       primary: Colors.black,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(0),
            //         ),
            //       )),
            //   onPressed: () => setState(() => {}),
            // ),
          ],
        );
      },
    );
  }
}
