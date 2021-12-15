import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_holder/hotkey_holder.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:magnetica/magnetica.dart';
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
      onInput: (a){},
      onDelete: (a){},
      event: () {
        print("this is shortcut A");
      });

  // @override
//   void initState() {
//     super.initState();
//     _keyCombo = HotKeyHolderKeyCombo(key: KeyCharacter.q, modifiers: [Modifier.control]);
//     print("innnnnnnnnnnnn");
//     context.read(windowHotKeyStateNotifier.notifier).set(_keyCombo!);
//     // _keyCombo = HotKeyHolderKeyCombo(key: KeyCharacter.q, modifiers: [Modifier.control]);
//     // // Future(() async {
//     // //
//     // // });
//     Future(() async {
//       // await Future.delayed(Duration(seconds: 50));
//       await context
//           .read(windowHotKeyStateNotifier.notifier)
//           .get()
//           .then((ssmKeyCombo) async {
//         if (ssmKeyCombo != null) {
//           print("ssmKeyCombo is ↓↓↓↓↓↓↓↓↓↓↓↓");
//           print(ssmKeyCombo!.keyCombo!.key);
//           print(ssmKeyCombo.keyCombo!.modifiers);
//           // _keyCombo = ssmKeyCombo!.keyCombo!;
//
// //           _keyCombo = HotKeyHolderKeyCombo(key: KeyCharacter.q, modifiers: [Modifier.control]);
// //           print("innnnnnnnnnnnn");
// //           context.read(windowHotKeyStateNotifier.notifier).set(_keyCombo!);
// // setState(() {});
//         }
//         // if (windowHotKey?.hotKey != null) {
//         //   await context
//         //       .read(windowHotKeyStateNotifier.notifier)
//         //       .register(windowHotKey!.hotKey!);
//         //   await HotKeyManager.instance.register(
//         //     windowHotKey!.hotKey!,
//         //     // keyDownHandler: _keyDownHandler,
//         //     keyUpHandler: (HotKey hotKey) {},
//         //   );
//         // }
//       });
//
//       // setState(() {
//       //   print("aftereeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrr");
//       //   hkeyHolder = HotKeyHolder(
//       //       hotKeyName: "shortcutA",
//       //       keyCombo: _keyCombo,
//       //       onInput: insertKeyCombo,
//       //       onDelete: deleteKeyCombo,
//       //       event: () {
//       //         print("this is shortcut A");
//       //       });
//       //
//       // });
//
//     });
//
//
//
//   }


  @override
  void initState() {
    super.initState();
    // _keyCombo = HotKeyHolderKeyCombo(key: KeyCharacter.q, modifiers: [Modifier.control]);
    // print("innnnnnnnnnnnn");
    // context.read(windowHotKeyStateNotifier.notifier).set(_keyCombo!);
  }

  void insertKeyCombo(HotKeyHolderKeyCombo keyCombo) {
    print(keyCombo.modifiers);
    print(keyCombo.key);
    context
          .read(windowHotKeyStateNotifier.notifier)
          .register("showKeyboardHotKey", HotKeyHolderKeyCombo(key: keyCombo.key, modifiers: keyCombo.modifiers), (){});
  }

  void deleteKeyCombo() {
    print(_keyCombo);
  }

  @override
  Widget build(BuildContext context) {
print("builllllllllllllllllllllldddddddddddddddddddddd");
    // return _buildBody(context);
    // return hkeyHolder;
    // return HotKeyHolder(
    //     hotKeyName: "shortcutA",
    //     keyCombo: _keyCombo,
    //     onInput: insertKeyCombo,
    //     onDelete: deleteKeyCombo,
    //     event: () {
    //       print("this is shortcut A");
    //     });
return Consumer(
      builder: (context, watch, child) {
        final keyCombo = watch(windowHotKeyStateNotifier).keyCombo;
        // final currentPage = watch(windowHotKeyStateNotifier.notifier).currentPage;
        bool isFavorite = false;
        // if (posts.isNotEmpty) {
        //   isFavorite = posts[currentPage].liked;
        // }

        print("===================================");
        print(keyCombo?.key);
        print(keyCombo?.modifiers);
        HotKeyHolderKeyCombo? kc = null;
        if (keyCombo != null) {
          kc = HotKeyHolderKeyCombo(key: keyCombo!.key, modifiers: keyCombo.modifiers);

        }
        return HotKeyHolder(
            hotKeyName: "shortcutA",
            keyCombo: kc,
            onInput: insertKeyCombo,
            onDelete: deleteKeyCombo,
            event: () {
              print("this is shortcut A");
            });
      },
    );
  }
}
