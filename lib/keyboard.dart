import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switchsoulmonarch/keycode.dart';

class KeyboardPage extends StatefulWidget {
  const KeyboardPage({Key? key, required this.fn}) : super(key: key);

  final Function fn;

  @override
  State<KeyboardPage> createState() => _KeyboardPageState(fn: fn);
}

class IncrementIntent extends Intent {
  const IncrementIntent();
}

class DecrementIntent extends Intent {
  const DecrementIntent();
}

class Hoge extends Intent {
  const Hoge();
}

class _KeyboardPageState extends State<KeyboardPage> {
  _KeyboardPageState({required this.fn});

  Function fn;

  Widget _keyLabel(String keyName) {
    return Text(
      keyName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Theme.of(context).primaryColor,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _gestureDetector(String keyName, Function fn, double width,
      double height, EdgeInsetsGeometry margin, BoxDecoration decoration) {
    return GestureDetector(
        onTap: () => {fn()},
        child: Container(
          width: width,
          height: height,
          margin: margin,
          // color: Colors.red,
          decoration: decoration,
          child: _keyLabel(keyName),
        ));
  }

  Widget buildArrowKey(String keyName, Function fn) {
    return _gestureDetector(
        keyName,
        fn,
        70,
        30,
        const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
        BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ));
  }

  Widget buildEnterKey(String keyName, Function fn, String position) {
    double width = 0;
    double height = 85;
    EdgeInsetsGeometry? margin;
    BoxDecoration decoration;
    if (position == "top") {
      width = 100;
      margin = const EdgeInsets.only(top: 5, left: 5);
      decoration = const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
        color: Colors.white,
      );
    } else {
      width = 80;
      margin = const EdgeInsets.only(bottom: 5, left: 5);
      decoration = const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.white,
      );
    }
    return _gestureDetector(keyName, fn, width, height, margin, decoration);
  }

  Widget buildKey(String keyName, Function fn,
      {double width = 70, double height = 65}) {
    return _gestureDetector(
        keyName,
        fn,
        width,
        height,
        const EdgeInsets.all(5),
        BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyA): const Hoge(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncrementIntent: CallbackAction<IncrementIntent>(
            onInvoke: (IncrementIntent intent) => setState(() {
              print("AAA");
            }),
          ),
          DecrementIntent: CallbackAction<DecrementIntent>(
            onInvoke: (DecrementIntent intent) => setState(() {
              print("BBB");
            }),
          ),
          Hoge: CallbackAction<Hoge>(
            onInvoke: (Hoge intent) => setState(() {
              print("this is A");
            }),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    buildKey("ESC", fn, width: 100),
                    ...[
                      "F1",
                      "F2",
                      "F3",
                      "F4",
                      "F5",
                      "F6",
                      "F7",
                      "F8",
                      "F9",
                      "F10",
                      "F11",
                      "F12",
                      "鍵"
                    ].map((e) => buildKey(e, fn)),
                  ],
                ),
                Row(
                  children: [
                    buildKey("1", fn, width: 85),
                    ...[
                      "2",
                      "3",
                      "4",
                      "5",
                      "6",
                      "7",
                      "8",
                      "9",
                      "0",
                      "-",
                      "^",
                      "\\"
                    ].map((e) => buildKey(e, fn)),
                    buildKey("⌫", fn, width: 85),
                  ],
                ),
                Container(
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...[
                        "→",
                        "q",
                        "w",
                        "e",
                        "r",
                        "t",
                        "y",
                        "u",
                        "i",
                        "o",
                        "p",
                        "@",
                        "["
                      ].map((e) => buildKey(e, fn)),
                      buildEnterKey("↩", fn, "top"),
                    ],
                  ),
                ),
                Container(
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildKey("⌃", fn, width: 90),
                      ...[
                        SsmKeys.a.label!,
                        "s",
                        "d",
                        "f",
                        "g",
                        "h",
                        "j",
                        "k",
                        "l",
                        ";",
                        ":",
                        "]"
                      ].map((e) => buildKey(e, fn)),
                      buildEnterKey("↩", fn, "bottom"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    buildKey("⇧", fn, width: 125),
                    ...["z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "_"]
                        .map((e) => buildKey(e, fn)),
                    buildKey("⇧", fn, width: 125),
                  ],
                ),
                Row(
                  children: [
                    buildKey("⬆", fn),
                    buildKey("⌥", fn),
                    buildKey("⌘", fn, width: 85),
                    buildKey("英数", fn, width: 85),
                    buildKey("　", fn, width: 280),
                    buildKey("かな", fn, width: 85),
                    buildKey("⌘", fn, width: 85),
                    buildKey("fn", fn),
                    buildKey("←", fn),
                    Column(
                      children: [
                        buildArrowKey("↑", fn),
                        buildArrowKey("↓", fn),
                      ],
                    ),
                    buildKey("→", fn),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
